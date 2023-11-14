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
      deps: deps(),

      docs: [
        main: "about",
        extras: [
          "guides/introduction/about.md",
          "guides/architecture/architecture.md",
          "guides/architecture/modifiers.md",
          "guides/architecture/navigation.md",
          "guides/architecture/updates.md",
        ],
        groups_for_extras: [
          "Introduction": Path.wildcard("guides/introduction/*.md"),
          "Architecture": Path.wildcard("guides/architecture/*.md"),
        ],
        before_closing_body_tag: %{
          html: """
          <script src="https://cdn.jsdelivr.net/npm/mermaid@10.2.3/dist/mermaid.min.js"></script>
          <script>
            document.addEventListener("DOMContentLoaded", function () {
              mermaid.initialize({
                startOnLoad: false,
                theme: document.body.className.includes("dark") ? "dark" : "default"
              });
              let id = 0;
              for (const codeEl of document.querySelectorAll("pre code.mermaid")) {
                const preEl = codeEl.parentElement;
                const graphDefinition = codeEl.textContent;
                const graphEl = document.createElement("div");
                const graphId = "mermaid-graph-" + id++;
                mermaid.render(graphId, graphDefinition).then(({svg, bindFunctions}) => {
                  graphEl.innerHTML = svg;
                  bindFunctions?.(graphEl);
                  preEl.insertAdjacentElement("afterend", graphEl);
                  preEl.remove();
                });
              }
            });
          </script>
          """
        }
      ]
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
      {:makeup_swift, "~> 0.0.1"},
      {:makeup_json, "~> 0.1.0"},

      {:live_view_native_platform, "0.2.0-beta.0"},
      {:live_view_native_stylesheet, github: "liveview-native/live_view_native_stylesheet"},
      {:jason, "~> 1.2"},
      {:nimble_parsec, "~> 1.3"},
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
