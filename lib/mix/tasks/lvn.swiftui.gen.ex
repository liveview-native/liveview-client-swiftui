defmodule Mix.Tasks.Lvn.Swiftui.Gen do
  use Mix.Task

  alias Mix.LiveViewNative.Context

  @macos? :os.type() == {:unix, :darwin}

  @shortdoc "Generates the SwiftUI Project for LiveView Native"
  @moduledoc """
  #{@shortdoc}

     $ mix lvn.swiftui.gen

  ## Options

  * `--no-live-form` - don't include `LiveViewNative.LiveForm` in the generated templates
  * `--no-xcodegen` - don't generate the swiftui project
  * `--no-copy` - don't copy files into your Phoenix project
  """

  def run(args) do
    if Mix.Project.umbrella?() do
      Mix.raise(
        "mix lvn.swiftui.gen must be invoked from within your *_web application root directory"
      )
    end

    args = List.insert_at(args, 0, "swiftui")

    context = Context.build(args, __MODULE__)

    files = files_to_be_generated(context)

    copy_new_files(context, files)

    if Keyword.get(context.opts, :xcodegen, true) do
      run_xcodegen(context, @macos?)
    end

    :ok
  end

  def switches, do: [
    context_app: :string,
    web: :string,
    live_form: :boolean,
    xcodegen: :boolean,
    copy: :boolean
  ]

  def validate_args!([format]), do: [format]
  def validate_args!(_args) do
    Mix.raise("""
    mix lvn.swiftui.gen does not take any arguments, only the following switches:

    --context-app
    --web
    --no-live-form
    --no-xcodegen
    --no-copy
    """)
  end

  def files_to_be_generated(context) do
    root =
      Application.app_dir(:live_view_native_swiftui)
      |> Path.join("priv/templates/lvn.swiftui.gen/xcodegen/")

    web_prefix = Mix.Phoenix.web_path(context.context_app)

    copy_files? = Keyword.get(context.opts, :copy, true)
    xcodegen? = Keyword.get(context.opts, :xcodegen, true) && @macos?

    components_path = Path.join(web_prefix, "components")

    files =
      if xcodegen? do
        Path.wildcard(Path.join([root, "**/*"]))
        |> Enum.filter(&(!File.dir?(&1)))
        |> Enum.map(fn(path) ->
          type =
            path
            |> Path.extname()
            |> case do
            ".swift" -> :eex
            ".yml" -> :eex
            _any -> :text
          end

          path = Path.relative_to(path, root)

          {type, Path.join("xcodegen", path), rewrite_file_path(path, context)}
        end)
      else
        []
      end

    case copy_files? do
      true -> List.insert_at(files, 0, {:eex, "core_components.ex", Path.join(components_path, "core_components.swiftui.ex")})
      _ -> files
    end
  end

  defp rewrite_file_path(file_path, %{base_module: base_module, native_path: native_path}) do
    file_path = String.replace(file_path, "TemplateApp", inspect(base_module))
    Path.join(native_path, file_path)
  end

  defp copy_new_files(%Context{} = context, files) do
    version = Application.spec(:live_view_native_swiftui)[:vsn]
    apps = Mix.Project.deps_apps()

    live_form_opt? = Keyword.get(context.opts, :live_form, true)
    live_form_app? = Enum.member?(apps, :live_view_native_live_form) || Mix.env() == :test # yeah, I know but it's a generator

    binding = [
      context: context,
      assigns: %{
        app_namespace: inspect(context.base_module),
        gettext: true,
        version: version,
        live_form?: live_form_opt? && live_form_app?
      }
    ]

    apps = Context.apps(context.format)

    Mix.Phoenix.copy_from(apps, "priv/templates/lvn.swiftui.gen", binding, files)

    context
  end

  defp run_xcodegen(%{base_module: base_module, native_path: native_path} = context, true) do
    xcodegen_env = [
      {"LVN_APP_NAME", inspect(base_module)},
      {"LVN_BUNDLE_IDENTIFIER", "com.example.#{inspect(base_module)}"}
    ]

    spec_path = Path.join([native_path, "project.yml"])
    bin_path =
      :code.priv_dir(:live_view_native_swiftui)
      |> IO.iodata_to_binary()
      |> Path.join("bin/xcodegen")

    System.cmd(bin_path, ["generate", "-s", spec_path], env: xcodegen_env)

    remove_xcodegen_files(context)
  end

  defp run_xcodegen(_context, false),
    do: Mix.shell().info("You must run this task from MacOS to use xcodegen")

  defp remove_xcodegen_files(%{native_path: native_path} = context) do
    ["base_spec.yml", "project_watchos.yml", "project.yml"]
    |> Enum.map(&(Path.join([native_path, &1])))
    |> Enum.map(&File.rm/1)

    context
  end
end
