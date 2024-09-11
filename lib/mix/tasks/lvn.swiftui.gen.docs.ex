defmodule Mix.Tasks.Lvn.Swiftui.Gen.Docs do
  @moduledoc "Generates ex doc files for all SwiftUI views"

  use Mix.Task
  require Logger

  defp generate_swift_lvn_docs_command(doc_path), do: ~c"xcrun xcodebuild docbuild -scheme LiveViewNative -destination generic/platform=iOS -derivedDataPath #{doc_path} -skipMacroValidation -skipPackagePluginValidation"
  @swiftui_interface_path "Platforms/XROS.platform/Developer/SDKs/XROS.sdk/System/Library/Frameworks/SwiftUI.framework/Modules/SwiftUI.swiftmodule/arm64-apple-xros.swiftinterface"
  defp generate_modifier_documentation_extensions(xcode_path), do: ~c(xcrun swift run ModifierGenerator documentation-extensions --interface "#{Path.join(xcode_path, @swiftui_interface_path)}" --output Sources/LiveViewNative/LiveViewNative.docc/DocumentationExtensions)
  @generate_documentation_extensions ~c(xcrun swift package plugin --allow-writing-to-package-directory generate-documentation-extensions)
  defp modifier_list(xcode_path), do: ~s(xcrun swift run ModifierGenerator list --interface "#{Path.join(xcode_path, @swiftui_interface_path)}" --modifier-search-path Sources/LiveViewNative/Stylesheets/Modifiers)
  @xcode_select_print_path ~c(xcode-select --print-path)
  @allow_writing_to_package_dir_command ~c"xcrun swift package plugin --allow-writing-to-package-directory generate-documentation-extensions"
  @doc_folder "generated_docs"
  @cheatsheet_path "#{@doc_folder}/view-index.md"
  @modifier_cheatsheet_path "#{@doc_folder}/modifier-index.md"

  @shortdoc "Generates ex doc files for all SwiftUI views"
  def run(args) do
    dbg args
    {kwargs, [], []} = OptionParser.parse(args, strict: [doc_path: :string, no_generate_docc: :boolean])

    # Using a temporary folder outside of the project avoids ElixirLS file watching issues
    doc_path = Keyword.get(kwargs, :doc_path, Path.join(System.tmp_dir!(), "temp_swiftui_docs"))
      |> Path.absname()
    dbg doc_path

    Logger.info("Locating Xcode installation")
    xcode_path = :os.cmd(@xcode_select_print_path) |> to_string() |> String.trim()

    if not Keyword.get(kwargs, :no_generate_docc, false) do
      Logger.info("Enabling writing to package...")
      :os.cmd(@allow_writing_to_package_dir_command)

      Logger.info("Generating documentation extensions")
      :os.cmd(@generate_documentation_extensions)

      Logger.info("Generating modifier documentation extensions")
      :os.cmd(generate_modifier_documentation_extensions(xcode_path))

      Logger.info("Generating SwiftUI documentation files...")
      :os.cmd(generate_swift_lvn_docs_command(doc_path))
    end

    Logger.info("Generating LiveView Native documentation files...")
    # Ensure generated_docs folder exists
    File.mkdir("generated_docs")

    # generate documentation and cheatsheat
    views = Path.wildcard("Sources/LiveViewNative/Views/**/*.swift")
      |> Enum.map(fn view -> Path.basename(view, ".swift") end)
      |> Enum.sort()
      |> Enum.map(fn view ->
        {
          "`<#{view}>`",
          "#{doc_path}/Build/Products/Debug-iphoneos/LiveViewNative.doccarchive/data/documentation/liveviewnative/#{view}.json"
        }
      end)
    write_cheatsheet(
      "View Index",
      doc_path,
      views,
      @cheatsheet_path
    )

    Logger.info("Generating LiveView Native modifier documentation files...")
    modifiers = System.shell(modifier_list(xcode_path))
      |> elem(0)
      |> String.split("\n")
      |> Enum.map(fn modifier ->
        {
          modifier,
          "#{doc_path}/Build/Products/Debug-iphoneos/LiveViewNative.doccarchive/data/documentation/liveviewnative/_#{modifier}Modifier.json"
        }
      end)
    write_cheatsheet(
      "Modifier Index",
      doc_path,
      modifiers,
      @modifier_cheatsheet_path,
      true
    )

    if Keyword.get(kwargs, :doc_path) == nil do
      Logger.info("Cleaning up temporary files...")
      File.rm_rf(doc_path)
    end
  end

  defp write_cheatsheet(title, doc_path, paths, output_path, use_tabs \\ false) do
    # clear cheatsheet
    File.write!(output_path, "# #{title}\n")

    references = MapSet.new()
    for {name, path} <- paths do
      with {:ok, data} <- File.read(path) do
        docs = Jason.decode!(data)
        File.write!(output_path, "## #{name}\n", [:append])
        if use_tabs do
          File.write!(output_path, "<!-- tabs-open -->\n", [:append])
        end
        ctx = if use_tabs do
          docs
        else
          docs |> Map.put("inlineHeadings", true)
        end
        File.write!(output_path, modifier_cheatsheet(docs, ctx) <> "\n", [:append])
        if use_tabs do
          File.write!(output_path, "<!-- tabs-close -->\n", [:append])
        end
        reduce_references(docs, references)
      end
    end

    references = paths
    |> Enum.reduce(MapSet.new(), fn {_, path}, acc ->
      with {:ok, data} <- File.read(path)
      do
        docs = Jason.decode!(data)
        reduce_references(docs, acc)
      else
        _ -> acc
      end
    end)

    # collect references made in references
    references = Enum.reduce(references, references, fn reference, acc ->
      path = String.trim_leading(reference, "doc://LiveViewNative/documentation/LiveViewNative/")
      with {:ok, data} <- File.read("#{doc_path}/Build/Products/Debug-iphoneos/LiveViewNative.doccarchive/data/documentation/liveviewnative/#{path}.json")
      do
        docs = Jason.decode!(data)
        reduce_references(docs, acc)
      else
        _ -> acc
      end
    end)

    # write references to end of modifier index
    File.write!(output_path, "## Types\n", [:append])
    for reference <- Enum.sort(references) do
      File.write!(output_path, attribute_details(String.trim_leading(reference, "doc://LiveViewNative/documentation/LiveViewNative/"), doc_path) <> "\n", [:append])
    end
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

  ### Modifier Cheatsheet
  def modifier_cheatsheet(data), do: modifier_cheatsheet(data, data)

  def modifier_cheatsheet(
    %{ "primaryContentSections" => content },
    ctx
  ) do
    markdown(content, ctx |> Map.put("includeAllReferences", true))
  end

  def modifier_cheatsheet(_data, _ctx), do: ""

  ### Markdown
  def markdown(data), do: markdown(data, data)
  def markdown(
    %{
      "identifier" => %{"url" => url},
      "metadata" => %{"title" => title},
      "primaryContentSections" => content
    } = data,
    ctx
  ) do
    abstract = Map.get(data, "abstract", [])

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

    #{Enum.map(attributes, &attribute_details(Path.basename(url), &1, ctx.doc_path))}

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

  def markdown(%{"type" => "heading", "text" => text, "level" => level}, %{"inlineHeadings" => true}) when level < 3,
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
      (items
      |> Enum.map(fn %{"content" => content} -> "* #{markdown(content, ctx)}" end)
      |> Enum.join())
      <> "\n"

  def markdown(
    %{"type" => "reference", "identifier" => "doc:" <> _ = identifier},
    %{"references" => references, "includeAllReferences" => true}
  ) do
    %{"title" => title} = Map.get(references, identifier)
    hash = "#{identifier}/1"
    "[`#{title}`](##{hash})"
  end

  def markdown(
    %{"type" => "reference", "identifier" => identifier},
    %{"references" => references, "identifier" => %{"url" => base_url}}
  ) do
    %{"title" => title, "url" => url} = Map.get(references, identifier)
    hash = "#{url}/1"

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

  defp attribute_details(view, identifier, doc_path) do
    attribute_details("#{view}/#{Path.basename(identifier)}", doc_path)
  end

  defp attribute_details(path, doc_path) do
    "#{doc_path}/Build/Products/Debug-iphoneos/LiveViewNative.doccarchive/data/documentation/liveviewnative/#{path}.json"
    |> File.read()
    |> case do
      {:ok, data} ->
        docs = Jason.decode!(data)

        title = Map.get(docs, "metadata", %{}) |> Map.get("title", "")
        url = Map.get(docs, "identifier", %{}) |> Map.get("url", "")
        abstract = Map.get(docs, "abstract", [])
        content = Map.get(docs, "primaryContentSections", [])

        docs = Map.put(docs, "inlineHeadings", true) |> Map.put("includeAllReferences", true)
        hash = "#{url}/1"

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
      {:error, _} -> ""
    end
  end

  defp reduce_references(
    %{"type" => "reference", "identifier" => identifier},
    acc
  ) do
    MapSet.put(acc, identifier)
  end

  defp reduce_references(
    %{ "primaryContentSections" => content },
    acc
  ), do: reduce_references(content, acc)

  defp reduce_references(markdown, acc) when is_list(markdown),
    do: markdown |> Enum.reduce(acc, fn x, acc -> reduce_references(x, acc) end)

  defp reduce_references(
    %{"kind" => "content", "content" => content},
    acc
  ), do: reduce_references(content, acc)

  defp reduce_references(
    %{"type" => "paragraph", "inlineContent" => content},
    acc
  ), do: reduce_references(content, acc)

  defp reduce_references(
    %{"type" => "unorderedList", "items" => items},
    acc
  ), do: items |> Enum.reduce(acc, fn %{"content" => content}, acc -> reduce_references(content, acc) end)

  defp reduce_references(_markdown, acc), do: acc
end
