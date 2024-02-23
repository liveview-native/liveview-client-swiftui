defmodule Mix.Tasks.Lvn.SwiftUi.GenerateDocumentation do
  @moduledoc "Generates ex doc files for all SwiftUI views"

  use Mix.Task
  require Logger

  @temp_doc_folder "../lvn_swiftui_docs"
  @allow_writing_to_package_dir_command ~c"xcrun swift package plugin --allow-writing-to-package-directory generate-documentation-extensions"
  @generate_swift_lvn_docs_command ~c"xcodebuild docbuild -scheme LiveViewNative -destination generic/platform=iOS -derivedDataPath #{@temp_doc_folder} -skipMacroValidation -skipPackagePluginValidation"
  @doc_folder "generated_docs"
  @cheatsheet_path "#{@doc_folder}/view-index.cheatmd"

  @shortdoc "Generates ex doc files for all SwiftUI views"
  def run(_) do
    Logger.info("Enabling writing to package...")
    :os.cmd(@allow_writing_to_package_dir_command)
    Logger.info("Generating SwiftUI documentation files...")
    :os.cmd(@generate_swift_lvn_docs_command)

    Logger.info("Generating LiveView Native documentation files...")
    # Ensure generated_docs folder exists
    File.mkdir("generated_docs")

    # clear cheatsheet
    File.write!(@cheatsheet_path, "# View Index\n")

    # generate documentation and cheatsheat
    for {category, views} <- categorized_views() do
      # build cheatsheet sections
      File.write!(@cheatsheet_path, "## #{category}\n{: .col-2}\n", [:append])

      for view <- views do
        with {:ok, data} <-
               File.read(
                 "#{@temp_doc_folder}/Build/Products/Debug-iphoneos/LiveViewNative.doccarchive/data/documentation/liveviewnative/#{view}.json"
               ) do
          docs = Jason.decode!(data)
          path = "#{@doc_folder}/#{category}/#{view}.md"
          File.mkdir_p!(Path.dirname(path))
          File.write!(path, markdown(docs, docs))

          # build cheatsheet entries
          File.write!(@cheatsheet_path, cheatsheet(docs, docs) <> "\n", [:append])
        end
      end
    end

    Logger.info("Cleaning up temporary files...")
    File.rm_rf(@temp_doc_folder)
  end

  ### Cheatsheet
  def cheatsheet(data), do: cheatsheet(data, data)
  def cheatsheet(
        %{
          "metadata" => %{"title" => title},
          "abstract" => abstract,
          "primaryContentSections" => content
        },
        ctx
      ) do
    """
    ### `#{title}`
    #{markdown(abstract, ctx)}

    #{cheatsheet(content, ctx)}
    """
  end

  def cheatsheet(data, ctx) when is_list(data),
    do: data |> Enum.map(&cheatsheet(&1, ctx)) |> Enum.join()

  def cheatsheet(%{"kind" => "content", "content" => content}, ctx), do: cheatsheet(content, ctx)

  def cheatsheet(%{"type" => "paragraph", "inlineContent" => content}, ctx),
    do: "#{cheatsheet(content, ctx)}\n"

  def cheatsheet(%{"type" => "codeListing"} = code, ctx), do: markdown(code, ctx)

  def cheatsheet(_data, _ctx), do: ""

  ### Markdown
  def markdown(data), do: markdown(data, data)
  def markdown(
        %{
          "identifier" => %{"url" => url},
          "metadata" => %{"title" => title},
          "abstract" => abstract,
          "primaryContentSections" => content
        } = data,
        ctx
      ) do
    trimmed_title = title |> String.replace("<", "") |> String.replace(">", "")

    attributes =
      Enum.find(
        Map.get(data, "topicSections", []),
        %{"identifiers" => []},
        &(&1["title"] == "Instance Properties")
      )["identifiers"]
      |> Enum.filter(&(Path.basename(&1) != "body"))

    references = """
    <!-- attribute list -->
    # References

    #{Enum.map(attributes, &attribute_details(Path.basename(url), &1))}

    <!-- end attribute list -->
    """

    """
    # #{trimmed_title}
    <!-- tooltip support -->
    <div id="#{trimmed_title}/1" class="detail">

    <h1 style="display: none;">

    #{title |> String.replace("<", "&lt;") |> String.replace(">", "&gt;")}

    </h1>

    <section class="docstring">
      #{markdown(abstract, ctx) |> ExDoc.Markdown.to_ast() |> ExDoc.DocAST.to_string()}
    </section>

    </div>
    <!-- end tooltip support -->

    #{markdown(content, ctx)}

    #{if length(attributes) > 0, do: references, else: ""}
    """
  end

  def markdown(data, ctx) when is_list(data),
    do: data |> Enum.map(&markdown(&1, ctx)) |> Enum.join()

  def markdown(%{"kind" => "content", "content" => content}, ctx), do: markdown(content, ctx)

  def markdown(%{"type" => "text", "text" => text}, _ctx), do: text

  def markdown(%{"type" => "heading", "text" => text}, %{"inlineHeadings" => true}),
    do: "### #{text}\n\n"

  def markdown(%{"type" => "heading", "level" => level, "text" => text}, _ctx),
    do: "#{String.duplicate("#", level)} #{text}\n"

  def markdown(%{"type" => "paragraph", "inlineContent" => content}, ctx),
    do: "#{markdown(content, ctx)}\n"

  def markdown(%{"type" => "codeListing", "syntax" => "html"} = code, ctx),
    do: markdown(Map.put(code, "syntax", "heex"), ctx)

  def markdown(%{"type" => "codeListing", "syntax" => syntax, "code" => code}, _ctx),
    do: "\n```#{syntax}\n#{Enum.join(code, "\n")}\n```\n"

  def markdown(%{"type" => "codeVoice", "code" => code}, _ctx), do: "`#{code}`"

  def markdown(%{"type" => "unorderedList", "items" => items}, ctx),
    do:
      items
      |> Enum.map(fn %{"content" => content} -> "* #{markdown(content, ctx)}" end)
      |> Enum.join()

  def markdown(
        %{"type" => "reference", "identifier" => identifier},
        %{"references" => references, "identifier" => %{"url" => base_url}}
      ) do
    %{"title" => title, "url" => url} = Map.get(references, identifier)
    hash = "#{title |> String.replace("<", "") |> String.replace(">", "")}/1"

    resolved_url =
      case url do
        "/documentation/liveviewnative/" <> rest ->
          if String.starts_with?(rest, "#{base_url |> Path.basename() |> String.downcase()}/") do
            "##{hash}"
          else
            "#{rest}.html##{hash}"
          end

        url ->
          url
      end

    "[`#{title}`](#{resolved_url})"
  end

  def markdown(_data, _ctx), do: ""

  defp attribute_details(view, identifier) do
    {:ok, data} =
      File.read(
        "#{@temp_doc_folder}/Build/Products/Debug-iphoneos/LiveViewNative.doccarchive/data/documentation/liveviewnative/#{view}/#{Path.basename(identifier)}.json"
      )

    docs = Jason.decode!(data)

    %{
      "metadata" => %{"title" => title},
      "abstract" => abstract,
      "primaryContentSections" => content
    } = docs

    docs = Map.put(docs, "inlineHeadings", true)
    hash = "#{title}/1"

    """
    <section id="#{hash}" class="detail">
      <div class="detail-header">
        <a href="##{hash}" class="detail-link" title="Link to this reference">
          <i class="ri-link-m" aria-hidden="true"></i>
          <span class="sr-only">Link to this reference</span>
        </a>
        <h1 class="signature">#{title}</h1>
      </div>
      <section class="docstring">

    #{markdown(abstract, docs) |> ExDoc.Markdown.to_ast() |> ExDoc.DocAST.to_string()}

    #{markdown(content, docs) |> ExDoc.Markdown.to_ast() |> ExDoc.DocAST.to_string()}

      </section>
    </section>
    """
  end

  @spec categorized_views() :: %{String.t() => [String.t()]}
  defp categorized_views do
    Path.wildcard("Sources/LiveViewNative/Views/**/*.swift")
    |> Enum.group_by(
      &Path.basename(Path.dirname(&1)),
      &Path.basename(&1, ".swift")
    )
  end
end
