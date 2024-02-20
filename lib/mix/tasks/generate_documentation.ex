defmodule Mix.Tasks.Lvn.SwiftUi.GenerateDocumentation do
  @moduledoc "Generates ex doc files for all SwiftUI views"

  use Mix.Task

  @base_path "generated_docs"
  @cheatsheet_path "#{@base_path}/view-index.cheatmd"

  @shortdoc "Generates ex doc files for all SwiftUI views"
  def run(_) do
    # clear cheatsheet
    File.write!(@cheatsheet_path, "# View Index\n")

    categorized_views = Path.wildcard("Sources/LiveViewNative/Views/**/*.swift")
      |> Enum.group_by(
        &(Path.basename(Path.dirname(&1))),
        &(Path.basename(&1, ".swift"))
      )
    for {category, views} <- categorized_views do
      # build cheatsheet sections
      File.write!(@cheatsheet_path, "## #{category}\n{: .col-2}\n", [:append])

      for view <- views do
        with {:ok, data} <- File.read("docc_build/Build/Products/Debug-iphoneos/LiveViewNative.doccarchive/data/documentation/liveviewnative/#{view}.json") do
          docs = Jason.decode!(data)
          path = "#{@base_path}/#{category}/#{view}.md"
          File.mkdir_p!(Path.dirname(path))
          File.write!(path, markdown(docs, docs))

          # build cheatsheet entries
          File.write!(@cheatsheet_path, cheatsheet(docs, docs) <> "\n", [:append])
        end
      end
    end
  end

  ### Markdown
  defp markdown(
    %{
      "identifier" => %{ "url" => url },
      "metadata" => %{ "title" => title },
      "abstract" => abstract,
      "primaryContentSections" => content
    } = data,
    ctx
  ) do
    trimmed_title = title |> String.replace("<", "") |> String.replace(">", "")
    attributes = Enum.find(Map.get(data, "topicSections", []), %{ "identifiers" => [] }, &(&1["title"] == "Instance Properties"))["identifiers"]
      |> Enum.filter(&(Path.basename(&1) != "body"))
    references = """
    <!-- attribute list -->
    # References

    #{Enum.map(attributes, &(attribute_details(Path.basename(url), &1)))}

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
      #{markdown(abstract, ctx) |> ExDoc.Markdown.to_ast |> ExDoc.DocAST.to_string}
    </section>

    </div>
    <!-- end tooltip support -->

    #{markdown(content, ctx)}

    #{if length(attributes) > 0, do: references, else: ""}
    """
  end

  defp markdown(data, ctx) when is_list(data), do: data |> Enum.map(&(markdown(&1, ctx))) |> Enum.join()

  defp markdown(%{ "kind" => "content", "content" => content }, ctx), do: markdown(content, ctx)

  defp markdown(%{ "type" => "text", "text" => text }, _ctx), do: text
  defp markdown(%{ "type" => "heading", "text" => text }, %{ "inlineHeadings" => true }), do: "### #{text}\n\n"
  defp markdown(%{ "type" => "heading", "level" => level, "text" => text }, _ctx), do: "#{String.duplicate("#", level)} #{text}\n"
  defp markdown(%{ "type" => "paragraph", "inlineContent" => content }, ctx), do: "#{markdown(content, ctx)}\n"

  defp markdown(%{ "type" => "codeListing", "syntax" => "html" } = code, ctx), do: markdown(Map.put(code, "syntax", "heex"), ctx)
  defp markdown(%{ "type" => "codeListing", "syntax" => syntax, "code" => code }, _ctx), do: "\n```#{syntax}\n#{Enum.join(code, "\n")}\n```\n"
  defp markdown(%{ "type" => "codeVoice", "code" => code }, _ctx), do: "`#{code}`"

  defp markdown(%{ "type" => "unorderedList", "items" => items }, ctx), do: items
    |> Enum.map(fn %{ "content" => content } -> "* #{markdown(content, ctx)}" end)
    |> Enum.join()

  defp markdown(
    %{ "type" => "reference", "identifier" => identifier },
    %{ "references" => references, "identifier" => %{ "url" => base_url } }
  ) do
    %{ "title" => title, "url" => url } = Map.get(references, identifier)
    hash = "#{title |> String.replace("<", "") |> String.replace(">", "")}/1"
    resolved_url = case url do
      "/documentation/liveviewnative/" <> rest ->
        if String.starts_with?(rest, "#{base_url |> Path.basename |> String.downcase}/") do
          "##{hash}"
        else
          "#{rest}.html##{hash}"
        end
      url ->
        url
    end
    "[`#{title}`](#{resolved_url})"
  end

  defp markdown(_data, _ctx), do: ""

  defp attribute_details(view, identifier) do
    {:ok, data} = File.read("docc_build/Build/Products/Debug-iphoneos/LiveViewNative.doccarchive/data/documentation/liveviewnative/#{view}/#{Path.basename(identifier)}.json")
    docs = Jason.decode!(data)
    %{ "metadata" => %{ "title" => title }, "abstract" => abstract, "primaryContentSections" => content } = docs
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

    #{markdown(abstract, docs) |> ExDoc.Markdown.to_ast |> ExDoc.DocAST.to_string}

    #{markdown(content, docs) |> ExDoc.Markdown.to_ast |> ExDoc.DocAST.to_string}

      </section>
    </section>
    """
  end

  ### Cheatsheet

  defp cheatsheet(
    %{
      "metadata" => %{ "title" => title },
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

  defp cheatsheet(data, ctx) when is_list(data), do: data |> Enum.map(&(cheatsheet(&1, ctx))) |> Enum.join()

  defp cheatsheet(%{ "kind" => "content", "content" => content }, ctx), do: cheatsheet(content, ctx)

  defp cheatsheet(%{ "type" => "paragraph", "inlineContent" => content }, ctx), do: "#{cheatsheet(content, ctx)}\n"

  defp cheatsheet(%{ "type" => "codeListing" } = code, ctx), do: markdown(code, ctx)

  defp cheatsheet(_data, _ctx), do: ""
end
