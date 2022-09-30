use std::{
    borrow::Cow,
    collections::{HashMap, HashSet},
    fs::read_dir,
    io::{stdout, Write},
    path::{Path, PathBuf},
};

use anyhow::anyhow;
use clap::Parser;
use git2::{IndexAddOption, Repository};
use serde::Deserialize;
use walkdir::WalkDir;

mod docc;

fn main() -> anyhow::Result<()> {
    let opts = Opts::parse();

    let repo = initialize_repo(&opts)?;

    apply_tutorial_sections(&opts, &repo)?;

    Ok(())
}

#[derive(Parser, Debug)]
struct Opts {
    #[clap(short, long, action = clap::ArgAction::Count)]
    verbose: u8,
    #[clap(long = "repo")]
    repo_path: PathBuf,
    #[clap(long = "package")]
    package_path: PathBuf,
    #[clap(long, action = clap::ArgAction::SetTrue)]
    skip_checks: bool,
}

impl Opts {
    fn debug(&self) -> bool {
        self.verbose > 0
    }

    fn very_debug(&self) -> bool {
        self.verbose > 1
    }
}

// rutsfmt doesn't like the nested macros
#[rustfmt::skip]
macro_rules! make_debug {
    // mfw $$ got unstabilized
    ($d:tt $name:ident) => {
        macro_rules! $name {
            ($d opts:expr, $d($d args:expr),*) => {
                if $d opts.$name() {
                    println!($d($d args),*);
                }
            }
        }
    };
}
make_debug!($ debug);
make_debug!($ very_debug);

fn initialize_repo(opts: &Opts) -> anyhow::Result<Repository> {
    if opts.repo_path.exists() {
        debug!(opts, "Removing existing repo");
        std::fs::remove_dir_all(&opts.repo_path)
            .map_err(|e| anyhow!("deleting repo dir: {:?}", e))?;
    }
    std::fs::create_dir_all(&opts.repo_path).map_err(|e| anyhow!("creating repo dir: {:?}", e))?;

    let repo = Repository::init(&opts.repo_path)?;
    repo.remote("origin", "git@github.com:liveviewnative/ios-tutorial.git")
        .map_err(|e| anyhow!("adding remote: {:?}", e))?;

    for entry in WalkDir::new("base") {
        let entry = entry?;
        if entry.file_type().is_dir() {
            continue;
        }
        let path = entry.path();
        let dest = opts.repo_path.join(path.strip_prefix("base").unwrap());
        std::fs::create_dir_all(dest.parent().unwrap())
            .map_err(|e| anyhow!("creating file parent dir: {:?}", e))?;
        std::fs::copy(path, dest)?;
    }

    verify_build(opts, &[Project::App, Project::Backend].into(), true)?;

    commit(opts, &repo, "Initial commit", true).map_err(|e| anyhow!("initial commit: {:?}", e))?;

    debug!(opts, "Created initial commit");

    Ok(repo)
}

fn apply_tutorial_sections(opts: &Opts, repo: &Repository) -> anyhow::Result<()> {
    let tutorials_path = opts
        .package_path
        .join("Sources/PhoenixLiveViewNative/PhoenixLiveViewNative.docc/Tutorials/");
    let entries =
        read_dir(tutorials_path).map_err(|e| anyhow!("reading tutorials dir: {:?}", e))?;

    let mut sections = vec![];

    for entry in entries {
        let entry = entry?;
        if !entry.file_type().expect("file type").is_file()
            || !entry.file_name().to_str().unwrap().ends_with(".tutorial")
        {
            continue;
        }

        let path = entry.path();
        let s = std::fs::read_to_string(&path)?;
        let node = docc::parse(&s);
        if let Some(tutorial) = parse_tutorial_opts(opts, &node)? {
            assert!(node.is_directive("Tutorial"));
            sections.push((path, tutorial, node));
        } else {
            debug!(
                opts,
                "Skipping section, didn't find tutorial comment in {:?}", path
            );
        }
    }

    sections.sort_by_key(|v| v.1.index);

    for section in sections {
        debug!(opts, "Applying tutorial section at {:?}", section.0);
        let title = section
            .2
            .depth_first()
            .find_map(|node| match node {
                docc::Node::Directive { name, args, .. } if name == "Intro" => args.get("title"),
                _ => None,
            })
            .expect("@Tutorial to have @Intro with title");

        apply_tutorial_file(opts, &section.2)
            .map_err(|e| anyhow!("applying {:?}: {:?}", section.0, e))?;

        commit(
            opts,
            &repo,
            &format!("Section {}: {}", section.1.index, title),
            false,
        )?;

        debug!(opts, "Created commit for section {}", section.1.index);
    }

    Ok(())
}

fn parse_tutorial_opts(opts: &Opts, node: &docc::Node) -> anyhow::Result<Option<Tutorial>> {
    match node {
        docc::Node::Directive {
            ref name, children, ..
        } if name == "Tutorial" => match children.first() {
            Some(docc::Node::Comment(toml_str)) => Ok(Some(toml::from_str::<Tutorial>(toml_str)?)),
            _ => {
                very_debug!(opts, "No @Comment in @Tutorial");
                Ok(None)
            }
        },
        _ => Ok(None),
    }
}

#[derive(Deserialize)]
struct Tutorial {
    index: usize,
}

fn apply_tutorial_file(opts: &Opts, node: &docc::Node) -> anyhow::Result<()> {
    let mut changed_projects = HashSet::new();
    let mut mix_exs_changed = false;

    let sections = node
        .depth_first()
        .filter(|node| node.is_directive("Section"));
    for (section_idx, section) in sections.enumerate() {
        let steps = section
            .depth_first()
            .filter(|node| node.is_directive("Step"));
        for (step_idx, step) in steps.enumerate() {
            let step_result = apply_tutorial_step(opts, step).map_err(|e| {
                anyhow!("section {} step {}: {:?}", section_idx + 1, step_idx + 1, e)
            })?;
            changed_projects = &changed_projects | &step_result.changed_projects;
            mix_exs_changed |= step_result.mix_exs_changed;
        }
    }

    verify_build(opts, &changed_projects, mix_exs_changed)?;

    Ok(())
}

fn apply_tutorial_step(opts: &Opts, step: &docc::Node) -> anyhow::Result<ApplyStepResult> {
    let mut comment: Option<&str> = None;
    let mut code: Option<&HashMap<String, String>> = None;
    for node in step.children() {
        match node {
            docc::Node::Comment(s) => {
                comment = Some(s);
            }
            docc::Node::Directive { name, args, .. } if name == "Code" => {
                code = Some(args);
            }
            _ => (),
        }
    }

    if code.is_none() {
        // steps don't have to have code (some have images)
        return Ok(ApplyStepResult {
            changed_projects: HashSet::new(),
            mix_exs_changed: false,
        });
    }

    let comment = comment.ok_or(anyhow!("expected @Step to have @Comment"))?;
    let code_args = code.unwrap();
    let file = code_args
        .get("file")
        .ok_or(anyhow!("expected file arg in @Code"))?;

    let mut changed_projects = HashSet::new();
    let mut mix_exs_changed = false;

    let container = toml::from_str::<CodeContainer>(comment)?;
    match container {
        CodeContainer::Skip => {
            very_debug!(opts, "Skipping @Code for {}", file);
        }
        CodeContainer::Code(code) => {
            let effective_path = (&code.path)
                .as_ref()
                .map(|p| Cow::Borrowed(p))
                .unwrap_or_else(|| {
                    Cow::Owned(PathBuf::from(
                        code_args.get("name").expect("expected name arg in @Code"),
                    ))
                });
            apply_code(opts, &code, &file, &effective_path)?;
            changed_projects.insert(code.project);
            if effective_path.ends_with("mix.exs") {
                mix_exs_changed = true;
            }
        }
    }

    Ok(ApplyStepResult {
        changed_projects,
        mix_exs_changed,
    })
}

struct ApplyStepResult {
    changed_projects: HashSet<Project>,
    mix_exs_changed: bool,
}

enum CodeContainer {
    Skip,
    Code(Code),
}

#[derive(Deserialize)]
struct Code {
    path: Option<PathBuf>,
    project: Project,
}

impl<'de> Deserialize<'de> for CodeContainer {
    fn deserialize<D>(deserializer: D) -> Result<Self, D::Error>
    where
        D: serde::Deserializer<'de>,
    {
        #[derive(Deserialize)]
        struct All {
            skip: Option<bool>,
            path: Option<PathBuf>,
            project: Option<Project>,
        }

        let all = All::deserialize(deserializer)?;
        if let Some(true) = all.skip {
            Ok(CodeContainer::Skip)
        } else {
            Ok(CodeContainer::Code(Code {
                path: all.path,
                project: all
                    .project
                    .expect("code definition without skip=true must have project"),
            }))
        }
    }
}

#[derive(Deserialize, Debug, Clone, Copy, PartialEq, Eq, Hash)]
#[serde(rename_all = "lowercase")]
enum Project {
    Backend,
    App,
}

impl Project {
    fn dir_name(&self) -> &'static str {
        match self {
            Project::Backend => "lvn_tutorial_backend",
            Project::App => "LVNTutorialApp",
        }
    }
}

fn apply_code(opts: &Opts, code: &Code, file: &str, effective_path: &Path) -> anyhow::Result<()> {
    very_debug!(
        opts,
        "Applying {} to {:?} in {:?}",
        file,
        effective_path,
        code.project
    );

    let source = opts
        .package_path
        .join("Sources/PhoenixLiveViewNative/PhoenixLiveViewNative.docc/Resources/")
        .join(file);
    let dest = opts
        .repo_path
        .join(code.project.dir_name())
        .join(effective_path);

    std::fs::create_dir_all(dest.parent().unwrap())?;
    std::fs::copy(source, dest)?;

    Ok(())
}

/// Commits all changes in the repo with the given message and updates HEAD.
fn commit(
    opts: &Opts,
    repo: &Repository,
    message: &str,
    is_initial: bool,
) -> Result<git2::Oid, git2::Error> {
    // TODO: this uses the user's configured name/email, should this use its own?
    let sig = repo.signature()?;
    let mut index = repo.index()?;
    index.add_all(["."], IndexAddOption::DEFAULT, None)?;
    index.write()?;
    let tree_id = index.write_tree()?;
    let tree = repo.find_tree(tree_id)?;

    let commit_id = if is_initial {
        repo.commit(Some("HEAD"), &sig, &sig, message, &tree, &[])?
    } else {
        let reference = repo.head()?;
        let commit = reference.peel_to_commit()?;
        repo.commit(Some("HEAD"), &sig, &sig, message, &tree, &[&commit])?
    };

    very_debug!(opts, "Committed {}", commit_id);

    Ok(commit_id)
}

fn verify_build(
    opts: &Opts,
    projects: &HashSet<Project>,
    mix_deps_changed: bool,
) -> anyhow::Result<()> {
    if opts.skip_checks {
        very_debug!(opts, "Skipping build checks");
        return Ok(());
    }

    if projects.contains(&Project::Backend) {
        debug!(opts, "Verifying backend builds...");

        // mix deps.get is slow, even if nothing changed, so only run it if something has
        if mix_deps_changed {
            expect_command(opts, Project::Backend, "mix", &["deps.get"])?;
        }

        expect_command(opts, Project::Backend, "mix", &["compile"])?;
    }

    if projects.contains(&Project::App) {
        debug!(opts, "Verifying app builds...");

        expect_command(
            opts,
            Project::App,
            "xcodebuild",
            &[
                "-scheme",
                "LVNTutorialApp",
                "-target",
                "LVNTutorialApp",
                "-destination",
                "generic/platform=iOS",
                "-derivedDataPath",
                "DerivedData",
            ],
        )?;
    }

    Ok(())
}

fn expect_command(opts: &Opts, project: Project, prog: &str, args: &[&str]) -> anyhow::Result<()> {
    print!("Running `{} {}`... ", prog, args.join(" "));
    stdout().flush()?;

    let mut cmd = duct::cmd(prog, args)
        .stderr_to_stdout()
        .dir(opts.repo_path.join(project.dir_name()));

    if opts.very_debug() {
        println!();
    } else {
        cmd = cmd.stdout_capture();
    }

    let result = cmd.run();

    match result {
        Ok(output) if output.status.success() => {
            if opts.very_debug() {
                println!("Running `{} {}` ✅", prog, args.join(" "));
            } else {
                println!("✅");
            }
            Ok(())
        }
        Ok(output) => {
            if opts.very_debug() {
                println!("Running `{} {}` ❌", prog, args.join(" "));
                // already printed cmd stdout
            } else {
                println!("❌");
                stdout().write_all(&output.stdout)?;
            }
            Err(anyhow!("command failed"))
        }
        Err(e) => {
            if opts.very_debug() {
                println!("Running `{} {}` ❌", prog, args.join(" "));
            } else {
                println!("❌");
            }
            Err(anyhow!(e))
        }
    }
}
