defmodule LiveViewNativeSwiftUi.MixProject do
  use Mix.Project

  def project do
    [
      app: :live_view_native_swift_ui,
      version: "0.0.10-rc.1",
      elixir: "~> 1.15",
      description: "LiveView Native platform for SwiftUI",
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
      {:jason, "~> 1.2"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:live_view_native_platform, "~> 0.0.8-rc.1"}
    ]
  end

  @source_url "https://github.com/liveview-native/liveview-client-swiftui"

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
