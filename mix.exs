defmodule LiveViewNative.SwiftUI.MixProject do
  use Mix.Project

  def project do
    [
      app: :live_view_native_swift_ui,
      version: "0.1.0",
      elixir: "~> 1.15",
      description: "LiveView Native platform for SwiftUI",
      elixirc_paths: elixirc_paths(Mix.env()),
      package: package(),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :live_view_native_platform]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:live_view_native_platform, "0.2.0-beta.1"},
      {:live_view_native_stylesheet, github: "liveview-native/live_view_native_stylesheet"},
      {:jason, "~> 1.2"},
      {:nimble_parsec, "~> 1.3"}
    ]
  end

  @source_url "https://github.com/liveview-native/liveview-client-swiftui"

  defp elixirc_paths(:test), do: ["lib", "test/mocks"]
  defp elixirc_paths(_), do: ["lib"]

  # Hex package configuration
  defp package do
    %{
      maintainers: ["May Matyi"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => @source_url
      },
      source_url: @source_url
    }
  end
end
