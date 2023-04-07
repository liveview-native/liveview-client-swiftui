//
//  TutorialRepoGenerator.swift
//
//
//  Created by Carson Katri on 3/21/23.
//

import Markdown
import Foundation
import RegexBuilder
import ArgumentParser

@main
struct TutorialRepoGenerator: ParsableCommand {
    @Option(help: "Path that contains the tutorial frontend and backend.", transform: { URL(filePath: $0) })
    private var repoPath: URL
    
    @Option(help: "Path that contains `.tutorial` files.", transform: { URL(filePath: $0) })
    private var tutorialsPath = URL(filePath: "Sources/LiveViewNative/LiveViewNative.docc/Tutorials")
    
    @Option(help: "Path that contains `@Code` files.", transform: { URL(filePath: $0) })
    private var resourcesPath = URL(filePath: "Sources/LiveViewNative/LiveViewNative.docc/Resources")
    
    @Option(help: "Path that contains the base repo to build on top of.", transform: { URL(filePath: $0) })
    private var tutorialRepoBasePath = URL(filePath: "util/tutorial_repo_base")
    
    @Option(help: "Argument passed to `git remote add origin`.")
    private var remoteOrigin: String = "git@github.com:liveview-native/ios-tutorial.git"
    
    @Flag(help: "Disable build checks performed after each section.")
    private var noCompile = false
    
    mutating func run() throws {
        // Setup executables with correct working directories.
        let git = Executable("git", currentDirectoryURL: repoPath)
        let xcodebuild = Executable("xcodebuild", currentDirectoryURL: repoPath.appending(component: Project.app.path), isXcodeBuildStyle: true)
        let mix = Executable("mix", currentDirectoryURL: repoPath.appending(component: Project.backend.path))
        
        // Create a fresh tutorial repo starting point.
        try? FileManager.default.removeItem(at: repoPath)
        try FileManager.default.copyItem(at: tutorialRepoBasePath, to: repoPath)
        
        // Create the git repository and initial commit.
        try git[dynamicMember: "init"]()
        try git.remote.add.origin(remoteOrigin)
        try git.add(".")
        try git.commit(message: "Initial commit")
        
        // Commit each `.tutorial` file's changes to the repo.
        for (offset, tutorial) in try FileManager.default.contentsOfDirectory(
            at: tutorialsPath,
            includingPropertiesForKeys: nil
        )
            .sorted(by: { $0.absoluteString.localizedStandardCompare($1.absoluteString) == .orderedAscending })
            .enumerated()
        where tutorial.pathExtension == "tutorial" {
            // Parse like DocC to handle directives.
            let document = try Document(parsing: tutorial, options: [.parseBlockDirectives, .parseSymbolLinks])
            
            // Find the steps and code paths.
            var visitor = TutorialWalker(resourcesURL: resourcesPath)
            visitor.visit(document)
            
            guard let title = visitor.tutorialTitle
            else { fatalError("Expected tutorial to have an @Intro(title:) directive.") }
            
            var changedProjects = Set<Project>()
            for step in visitor.steps {
                guard step.0["skip"] != "true",
                      let project = step.0["project"].flatMap(Project.init)
                else { continue }
                
                let destination = repoPath.appending(components: project.path, step.0["path"] ?? step.2)
                
                // Copy the changed files into the repo.
                try FileManager.default.createDirectory(at: destination.deletingLastPathComponent(), withIntermediateDirectories: true)
                try Data(contentsOf: step.1).write(to: destination, options: [])
                
                changedProjects.insert(project)
            }
            
            // Ensure the backend builds.
            if changedProjects.contains(.backend) && !noCompile {
                try mix("deps.get")
                try mix.compile()
            }

            // Ensure the app builds.
            if changedProjects.contains(.app) && !noCompile {
                try xcodebuild(
                    scheme: Project.app.path,
                    target: Project.app.path,
                    destination: "generic/platform=iOS",
                    derivedDataPath: "DerivedData",
                    CODE_SIGN_IDENTITY: "",
                    CODE_SIGNING_REQUIRED: "NO"
                )
            }

            // Commit the section.
            if !changedProjects.isEmpty {
                try git.add(".")
                try git.commit(message: "Section \(offset + 1): \(title)")
            }
        }
    }
    
    private struct TutorialWalker: MarkupWalker {
        let resourcesURL: URL
        init(resourcesURL: URL) {
            self.resourcesURL = resourcesURL
        }
        
        var tutorialTitle: String?
        var steps = [([String:String], URL, String)]()
        
        mutating func defaultVisit(_ markup: Markup) {
            descendInto(markup)
        }
        
        mutating func visitBlockDirective(_ blockDirective: BlockDirective) {
            switch blockDirective.name {
            case "Intro":
                if let title = blockDirective.argumentText.parseNameValueArguments().first(where: { $0.name == "title" })?.value {
                    self.tutorialTitle = title
                }
            case "Step":
                var stepWalker = StepWalker(resourcesURL: resourcesURL)
                stepWalker.visit(blockDirective)
                if let code = stepWalker.code,
                   let name = stepWalker.name
                {
                    self.steps.append((stepWalker.settings, code, name))
                }
            default:
                break
            }
            descendInto(blockDirective)
        }
    }

    private struct StepWalker: MarkupWalker {
        let resourcesURL: URL
        init(resourcesURL: URL) {
            self.resourcesURL = resourcesURL
        }
        
        var settings = [String:String]()
        var code: URL?
        var name: String?
        
        mutating func defaultVisit(_ markup: Markup) {
            descendInto(markup)
        }
        
        mutating func visitBlockDirective(_ blockDirective: BlockDirective) -> () {
            switch blockDirective.name {
            case "Comment":
                // Settings are formatted as:
                // @Comment {
                //     key = "value"
                //     key2 = "value2"
                // }
                let stepSetting = Regex {
                    Anchor.startOfLine
                    ZeroOrMore(.whitespace)
                    Capture {
                        OneOrMore("a"..."z")
                    }
                    ZeroOrMore(.whitespace)
                    "="
                    ZeroOrMore(.whitespace)
                    Optionally("\"")
                    Capture {
                        ZeroOrMore(CharacterClass.anyOf("\"\n").inverted)
                    }
                    Optionally("\"")
                    Anchor.endOfLine
                }
                self.settings = Dictionary(uniqueKeysWithValues: blockDirective.child(at: 0)!.format().replacing(try! Regex("“|”"), with: "\"").matches(of: stepSetting).map {
                    return (String($0.output.1), String($0.output.2))
                })
            case "Code":
                if let file = blockDirective.argumentText.parseNameValueArguments().first(where: { $0.name == "file" })?.value {
                    self.code = resourcesURL.appending(path: file)
                }
                if let name = blockDirective.argumentText.parseNameValueArguments().first(where: { $0.name == "name" })?.value {
                    self.name = name
                }
            default:
                break
            }
            descendInto(blockDirective)
        }
    }
}
