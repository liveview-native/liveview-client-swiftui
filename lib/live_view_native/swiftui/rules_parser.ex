defmodule LiveViewNative.SwiftUI.RulesParser do
  use LiveViewNative.Stylesheet.RulesParser, :swiftui
  alias LiveViewNative.SwiftUI.RulesParser.Modifiers
  alias LiveViewNative.SwiftUI.RulesParser.Parser

  defmacro __using__(_) do
    quote do
      import LiveViewNative.SwiftUI.RulesParser, only: [sigil_RULES: 2]
      import LiveViewNative.SwiftUI.RulesHelpers
    end
  end

  def parse(rules, opts \\ []) do
    file = Keyword.get(opts, :file) || ""
    module = Keyword.get(opts, :module) || ""
    line = Keyword.get(opts, :line) || 1
    variable_context = Keyword.get(opts, :variable_context, Elixir)

    context =
      opts
      |> Keyword.get(:context, %{})
      |> Map.put_new(:file, file)
      |> Map.put_new(:source_line, line)
      |> Map.put_new(:module, module)
      |> Map.put_new(
        :annotations,
        Application.get_env(:live_view_native_stylesheet, :annotations, false)
      )
      |> Map.put_new(:variable_context, variable_context)

    opts =
      opts
      |> Keyword.put(:context, context)
      |> Keyword.put(:file, file)
      |> Keyword.put(:module, module)
      |> Keyword.put(:line, line)

    result =
      rules
      |> Modifiers.modifiers(opts)
      |> Parser.error_from_result()

    case result do
      {:ok, [output], _unconsumed = "", _context, _current_line_and_offset, _} ->
        output

      {:ok, output, _unconsumed = "", _context, _current_line_and_offset, _} ->
        output

      {:error, message, _unconsumed, _context, {line, _}, _} ->
        raise SyntaxError,
          description: message,
          file: file,
          line: line
    end
  end
end
