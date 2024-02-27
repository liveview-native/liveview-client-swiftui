defmodule LiveViewNative.SwiftUI.MixProject do
  use Mix.Project

  @version "0.3.0-alpha.4"
  @source_url "https://github.com/liveview-native/liveview-client-swiftui"

  def project do
    [
      app: :live_view_native_swiftui,
      version: @version,
      elixir: "~> 1.15",
      description: description(),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      elixirc_paths: elixirc_paths(Mix.env()),
      docs: docs(),
      aliases: aliases()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp aliases do
    [
      docs: ["lvn.swift_ui.generate_documentation", "docs"]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: [:dev, :test], runtime: false},
      {:makeup_swift, "~> 0.0.1"},
      {:makeup_json, "~> 0.1.0"},
      {:makeup_eex, ">= 0.1.1"},
      {:floki, ">= 0.30.0", only: :test},
      # {:live_view_native, path: "../live_view_native", override: true},
      {:live_view_native, github: "liveview-native/live_view_native", branch: "main", override: true},
      # {:live_view_native_stylesheet, path: "../live_view_native_stylesheet", override: true},
      {:live_view_native_stylesheet, github: "liveview-native/live_view_native_stylesheet", branch: "main", override: true},
      # {:live_view_native_test, path: "../live_view_native_test", only: :test, override: true},
      {:live_view_native_test, github: "liveview-native/live_view_native_test", branch: "main", only: :test},
      {:jason, "~> 1.2"},
      {:nimble_parsec, "~> 1.3"}
    ]
  end

  defp docs do
    # Feature Flagging Docs
    extras =
      if System.get_env("INCLUDE_GENERATED_DOCS") do
        ["README.md"] ++ Path.wildcard("generated_docs/**/*.{md,cheatmd}")
      else
        ["README.md"]
      end

    groups_for_extras =
      if System.get_env("INCLUDE_GENERATED_DOCS") do
        Path.wildcard("generated_docs/*")
        |> Enum.map(fn p -> {Path.basename(p), Path.wildcard("#{p}/*.md")} end)
        |> Map.new()
      else
        []
      end

    [
      extras: extras,
      groups_for_extras: groups_for_extras,
      main: "readme",
      source_url: @source_url,
      source_ref: "v#{@version}"
    ]
  end

  defp description, do: "LiveView Native SwiftUI Client"

  defp package do
    %{
      maintainers: ["Brian Cardarella"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => @source_url,
        "Built by DockYard, Expert Elixir & Phoenix Consultants" =>
          "https://dockyard.com/phoenix-consulting"
      }
    }
  end
end
