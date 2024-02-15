defmodule Mix.Tasks.Lvn.SwiftUi.GenerateDocumentation do
  @moduledoc "Generates ex doc files for all SwiftUI views"

  use Mix.Task

  @shortdoc "Generates ex doc files for all SwiftUI views"
  def run(_) do
    categorized_views = Path.wildcard("Sources/LiveViewNative/Views/**/*.swift")
      |> Enum.group_by(
        &(Path.basename(Path.dirname(&1))),
        &(Path.basename(&1, ".swift"))
      )
    for {category, views} <- categorized_views do
      for view <- views do
        with {:ok, data} <- File.read("docc_build/Build/Products/Debug-iphoneos/LiveViewNative.doccarchive/data/documentation/liveviewnative/#{view}.json") do
          docs = Jason.decode!(data)
          path = "generated_docs/#{category}/#{view}.md"
          File.mkdir_p!(Path.dirname(path))
          File.write!(path, markdown(docs, docs))
        end
      end
    end
  end

  defp markdown(
    %{
      "metadata" => %{ "title" => title },
      "abstract" => abstract,
      "primaryContentSections" => content
    },
    ctx
  ) do
    """
    # `#{title |> String.replace("<", "&lt;") |> String.replace(">", "&gt;")}`
    #{markdown(abstract, ctx)}

    #{markdown(content, ctx)}
    """
  end

  defp markdown(data, ctx) when is_list(data), do: data |> Enum.map(&(markdown(&1, ctx))) |> Enum.join()

  defp markdown(%{ "kind" => "content", "content" => content }, ctx), do: markdown(content, ctx)

  defp markdown(%{ "type" => "text", "text" => text }, _ctx), do: text
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
    %{ "references" => references }
  ) do
    %{ "title" => title, "url" => url } = Map.get(references, identifier)
    resolved_url = case url do
      "/documentation/liveviewnative/" <> rest ->
        "#{rest}.html"
      url ->
        url
    end
    "[#{title}](#{resolved_url})"
  end

  defp markdown(_data, _ctx), do: ""
end
