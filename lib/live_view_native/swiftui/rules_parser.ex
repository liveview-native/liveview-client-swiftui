defmodule LiveViewNative.SwiftUI.RulesParser do
  @moduledoc false

  alias LiveViewNative.SwiftUI.RulesParser.Modifiers
  alias LiveViewNative.SwiftUI.RulesParser.Parser
  require Logger

  def parse(rules, opts \\ []) do
    file = Keyword.get(opts, :file) || ""
    module = Keyword.get(opts, :module) || ""
    line = Keyword.get(opts, :line) || 1
    variable_context = Keyword.get(opts, :variable_context, Elixir)
    expect_semicolons? = Keyword.get(opts, :expect_semicolons?, false)

    context =
      opts
      |> Keyword.get(:context, %{})
      |> Map.put_new(:file, file)
      |> Map.put_new(:source_line, line)
      |> Map.put_new(:module, module)
      |> Map.put_new(:expect_semicolons?, expect_semicolons?)
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
      {:ok, [output], warnings} ->
        log_warnings(warnings, file)
        output

      {:ok, output, warnings} ->
        log_warnings(warnings, file)
        output

      {:error, message, _unconsumed, _context, {line, _}, _} ->
        raise SyntaxError,
          description: message,
          file: file,
          line: line
    end
  end

  def log_warnings(warnings, file) do
    for {message, {line, _}, _offset} <- warnings do
      IO.warn(message, line: line, file: file)
    end
  end
end
