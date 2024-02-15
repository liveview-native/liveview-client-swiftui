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
          File.write!(path, markdown(docs))
        end
      end
    end
  end

  defp markdown(%{
    "metadata" => %{ "title" => title },
    "abstract" => abstract,
    "primaryContentSections" => content
  }) do
    """
    # `#{title |> String.replace("<", "&lt;") |> String.replace(">", "&gt;")}`
    #{markdown(abstract)}

    #{markdown(content)}
    """
  end

  defp markdown(data) when is_list(data), do: data |> Enum.map(&markdown/1) |> Enum.join()

  defp markdown(%{ "kind" => "content", "content" => content }), do: markdown(content)

  defp markdown(%{ "type" => "text", "text" => text }), do: text
  defp markdown(%{ "type" => "heading", "level" => level, "text" => text }), do: "#{String.duplicate("#", level)} #{text}\n"
  defp markdown(%{ "type" => "paragraph", "inlineContent" => content }), do: "#{markdown(content)}\n"
  defp markdown(%{ "type" => "codeListing", "syntax" => "html" } = code), do: markdown(Map.put(code, "syntax", "heex"))
  defp markdown(%{ "type" => "codeListing", "syntax" => syntax, "code" => code }), do: "\n```#{syntax}\n#{Enum.join(code, "\n")}\n```\n"
  defp markdown(%{ "type" => "codeVoice", "code" => code }), do: "`#{code}`"
  defp markdown(%{ "type" => "reference", "identifier" => identifier }), do: "[#{Path.basename(identifier)}](#{identifier})"
  defp markdown(%{ "type" => "unorderedList", "items" => items }), do: items
    |> Enum.map(fn %{ "content" => content } -> "* #{markdown(content)}" end)
    |> Enum.join()

  defp markdown(_data), do: ""
end
