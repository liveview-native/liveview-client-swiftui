defmodule LiveViewNative.SwiftUI.MixProject do
  use Mix.Project

  @version "0.3.0-rc.1"
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

  def cli do
    [
      preferred_envs: [docs: :docs, "hex.publish": :docs]
    ]
  end

  defp aliases do
    [
      docs: ["lvn.swiftui.gen.docs", "livebooks_to_markdown", "docs"]
    ]
  end

  defp elixirc_paths(:docs), do: ["lib"]
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ignore_docs_task(["lib"])

  defp ignore_docs_task(paths) do
    Enum.flat_map(paths, fn(path) ->
      Path.wildcard("#{path}/**/*.ex")
    end)
    |> Enum.filter(&(!(&1 =~ "lvn.swiftui.gen.docs")))
  end

  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: [:docs, :test]},
      {:makeup_swift, "~> 0.0.1", only: [:docs, :test]},
      {:makeup_json, "~> 0.1.0", only: [:docs, :test]},
      {:makeup_eex, ">= 0.1.1"},
      {:floki, ">= 0.30.0", only: :test},
      {:live_view_native, "~> 0.3.0-rc.1"},
      {:live_view_native_stylesheet, "~> 0.3.0-rc.1", only: :test},
      {:live_view_native_test, github: "liveview-native/live_view_native_test", tag: "v0.3.0", only: :test},
      {:nimble_parsec, "~> 1.3"}
    ]
  end

  defp docs do
    [
      extras: extras(),
      groups_for_extras: groups_for_extras(),
      main: "readme",
      source_url: @source_url,
      source_ref: "v#{@version}",
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
        <link
          href="https://cdn.jsdelivr.net/npm/remixicon@4.2.0/fonts/remixicon.css"
          rel="stylesheet"
        />
        """
      }
    ]
  end

  defp description, do: "LiveView Native SwiftUI Client"

  defp extras do
    guides = Path.wildcard("guides/**/*.md")
    generated_docs = Path.wildcard("generated_docs/**/*.{md,cheatmd}")

    livebooks = if System.get_env("LIVEBOOKS_ENABLED") do
      [
        "guides/markdown_livebooks/getting-started.md",
        "guides/markdown_livebooks/create-a-swiftui-application.md",
        "guides/markdown_livebooks/swiftui-views.md",
        "guides/markdown_livebooks/interactive-swiftui-views.md",
        "guides/markdown_livebooks/stylesheets.md",
        "guides/markdown_livebooks/native-navigation.md",
        "guides/markdown_livebooks/forms-and-validation.md"
      ]
    else
      []
    end

    ["README.md"] ++ guides ++ generated_docs ++ livebooks
  end

  defp groups_for_extras do
    guide_groups = [
      "Architecture": Path.wildcard("guides/architecture/*.md"),
      "Livebooks": ~r/markdown_livebooks/
    ]

    generated_groups =
      Path.wildcard("generated_docs/*")
      |> Enum.map(&({Path.basename(&1) |> String.to_atom(), Path.wildcard("#{&1}/*.md")}))

    guide_groups ++ generated_groups
  end

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
