defmodule Mix.Tasks.Lvn.SwiftUI.Install do
  @moduledoc "Installer Mix task for LiveView Native: `mix lvn.install`"
  use Mix.Task

  @requirements ["app.config"]

  @shortdoc "Installs LiveView Native for SwiftUI."
  def run(args) do
    {parsed_args, _, _} = OptionParser.parse(args, strict: [host_project_config: :string, task_settings: :string])
    host_project_config = Keyword.fetch!(parsed_args, :host_project_config)
    task_settings = Keyword.fetch!(parsed_args, :task_settings)

    make_native_project_dir(host_project_config)
    copy_xcodegen_files(host_project_config)
    prepare_source_files(host_project_config)
    rename_sources_directory(host_project_config)
    run_xcodegen(host_project_config, task_settings)
    remove_xcodegen_files(host_project_config)

    :ok
  end

  def lvn_install_config, do: %{
    client_name: "SwiftUI",
    mix_config: %{
      live_view_native: [
        plugins: [LiveViewNative.SwiftUI]
      ],
      live_view_native_stylesheet: [
        parsers: [
          swiftui: LiveViewNative.SwiftUI.RulesParser
        ]
      ]
    },
    prompts: [
      install_xcodegen: %{
        type: :confirm,
        label: "Xcodegen is required to generate an Xcode project for your app. Would you like to install it?",
        ignore: System.find_executable("xcodegen") != nil,
        on_yes: &install_xcodegen/0,
        on_no: &skip_swiftui_install/0
      },
      targets: %{
        type: :multiselect,
        label: "Select any number of deployment targets for your app.",
        options: ["iOS", "macOS", "watchOS", "tvOS (Experimental)"],
        default: ["iOS"],
        default_label: "1"
      }
    ]
  }

  ###

  defp install_xcodegen do
    cond do
      # Install with Mint
      System.find_executable("mint") ->
        status_message("running", "mint install yonaskolb/xcodegen")
        System.cmd("mint", ["install", "yonaskolb/xcodegen"])
        true

      # Install with Homebrew
      System.find_executable("brew") ->
        status_message("running", "brew install xcodegen")
        System.cmd("brew", ["install", "xcodegen"])
        true

      # Clone from GitHub (fallback)
      true ->
        File.mkdir_p("_build/tmp/xcodegen")
        status_message("running", "git clone https://github.com/yonaskolb/XcodeGen.git")
        System.cmd("git", ["clone", "https://github.com/yonaskolb/XcodeGen.git", "_build/tmp/xcodegen"])
        true
    end
  end

  defp make_native_project_dir(%{native_path: native_path}) do
    native_path
    |> Path.join("swiftui")
    |> File.mkdir_p()
  end

  defp copy_xcodegen_files(%{native_path: native_path}) do
    priv_dir = :code.priv_dir(:live_view_native_swiftui)
    native_project_dir = Path.join(native_path, "swiftui")
    xcodegen_path = Path.join(priv_dir, "xcodegen")

    File.cp_r(xcodegen_path, native_project_dir)
  end

  defp prepare_source_files(%{app_namespace: app_namespace, native_path: native_path} = host_project_config) do
    sources_path = Path.join(native_path, "swiftui/Sources/TemplateApp")

    sources_path
    |> File.ls!()
    |> Enum.map(&(Path.join(sources_path, &1)))
    |> Enum.filter(&(not File.dir?(&1)))
    |> Enum.map(&maybe_rename_file(&1, app_namespace))
    |> Enum.map(&prepare_source_file(&1, host_project_config))
  end

  defp prepare_source_file(source_file, %{} = task_settings) do
    body =
      source_file
      |> File.read!()
      |> String.replace("TemplateApp", task_settings.app_namespace)
      |> String.replace("%LVN_PREFERRED_ROUTE%", task_settings.preferred_route)
      |> String.replace("%LVN_PREFERRED_PROD_URL%", task_settings.preferred_prod_url)

    File.write!(source_file, body)
  end

  defp maybe_rename_file(source_file, app_namespace) do
    basename = Path.basename(source_file)

    if String.contains?(basename, "TemplateApp") do
      dirname = Path.dirname(source_file)
      new_path = Path.join(dirname, String.replace(basename, "TemplateApp", app_namespace))

      File.rename(source_file, new_path)

      new_path
    else
      source_file
    end
  end

  defp rename_sources_directory(%{app_namespace: app_namespace, native_path: native_path}) do
    sources_path = Path.join(native_path, "swiftui/Sources/TemplateApp")
    basename = Path.basename(sources_path)
    dirname = Path.dirname(sources_path)
    new_sources_path = Path.join(dirname, String.replace(basename, "TemplateApp", app_namespace))

    File.rename(sources_path, new_sources_path)
  end

  defp run_xcodegen(%{app_namespace: app_namespace, native_path: native_path}, %{targets: targets}) do
    lvn_ios = if "iOS" in targets, do: "iOS", else: ""
    lvn_macos = if "macOS" in targets, do: "macOS", else: ""
    lvn_tvos = if "tvOS (Experimental)" in targets, do: "tvOS", else: ""
    lvn_watchos_include_path = if "watchOS" in targets, do: "project_watchos.yml", else: "skip_spec.yml"
    xcodegen_env = [
      {"LVN_APP_NAME", app_namespace},
      {"LVN_BUNDLE_IDENTIFIER", "com.example.#{app_namespace}"},
      {"LVN_IOS", lvn_ios},
      {"LVN_MACOS", lvn_macos},
      {"LVN_TVOS", lvn_tvos},
      {"LVN_WATCHOS_INCLUDE_PATH", lvn_watchos_include_path}
    ]
    native_project_path = Path.join(native_path, "swiftui")

    if File.exists?("_build/tmp/xcodegen") do
      xcodegen_spec_path = Path.join(native_project_path, "project.yml")

      System.cmd("swift", ["run", "xcodegen", "generate", "-s", xcodegen_spec_path], cd: "_build/tmp/xcodegen", env: xcodegen_env)
    else
      System.cmd("xcodegen", ["generate"], cd: native_project_path, env: xcodegen_env)
    end
  end

  defp remove_xcodegen_files(%{native_path: native_path}) do
    client_path = Path.join(native_path, "swiftui")

    ["base_spec.yml", "project_ios.yml", "project_macos.yml", "project_watchos.yml", "project.yml", "skip_spec.yml"]
    |> Enum.map(&(Path.join(client_path, &1)))
    |> Enum.map(&File.rm/1)
  end

  defp status_message(label, message) do
    formatted_message = IO.ANSI.green() <> "* #{label} " <> IO.ANSI.reset() <> message

    IO.puts(formatted_message)
  end

  defp skip_swiftui_install do
    {:error, "Skipping Xcode project generation due to missing Xcodegen installation. Please create one manually at native/swiftui."}
  end
end
