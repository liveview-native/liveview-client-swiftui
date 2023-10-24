defmodule LiveViewNative.SwiftUI.RulesParser.PostProcessors do
  def to_attr_ast(rest, [[attr], "attr"], context, _line, _offset) when is_binary(attr) do
    {rest, [{:__attr__, [], attr}], context}
  end

  def wrap_in_tuple(rest, args, context, _line, _offset) do
    {rest, [List.to_tuple(Enum.reverse(args))], context}
  end

  def block_open_with_variable_to_ast(rest, [variable, string], context, _line, _offset) do
    {rest,
     [
       {:<>, [context: Elixir, imports: [{2, Kernel}]], [string, variable]}
     ], context}
  end

  def tag_as_elixir_code(rest, [quotable], context, _line, _offset) do
    {rest, [{Elixir, [], quotable}], context}
  end

  def to_elixir_variable_ast(rest, [variable_name], context, _line, _offset) do
    {rest, [{Elixir, [], {String.to_atom(variable_name), [], Elixir}}], context}
  end

  def to_implicit_ime_ast(rest, [[], variable_name], context, _line, _offset, _is_initial = true) do
    {rest, [{:., [], [nil, String.to_atom(variable_name)]}], context}
  end

  def to_implicit_ime_ast(
        rest,
        [args, variable_name],
        context,
        _line,
        _offset,
        _is_initial = true
      ) do
    {rest, [{:., [], [nil, {String.to_atom(variable_name), [], args}]}], context}
  end

  def to_implicit_ime_ast(rest, [[], variable_name], context, _line, _offset, false) do
    {rest, [String.to_atom(variable_name)], context}
  end

  def to_implicit_ime_ast(rest, [args, variable_name], context, _line, _offset, false) do
    {rest, [{String.to_atom(variable_name), [], args}], context}
  end

  def to_scoped_ime_ast(rest, [[] = _args, variable_name, scope], context, _line, _offset) do
    {rest, [String.to_atom(variable_name), String.to_atom(scope)], context}
  end

  def to_scoped_ime_ast(rest, [args, variable_name, scope], context, _line, _offset) do
    {rest, [{String.to_atom(variable_name), [], args}, String.to_atom(scope)], context}
  end

  def to_scoped_ime_ast(rest, [[nil, variable], scope], context, _line, _offset) do
    {rest, [variable, String.to_atom(scope)], context}
  end

  def to_scoped_ime_ast(rest, [variable, scope], context, _line, _offset) do
    {rest, [variable, String.to_atom(scope)], context}
  end

  defp combine_chain_ast_parts(outer, inner) when is_atom(outer) do
    if Regex.match?(~r/^[A-Z]/, Atom.to_string(outer)) do
      {:., [], [outer, inner]}
    else
      case outer do
        {:., [], [nil, part]} ->
          {:., [], [nil, {:., [], [part, inner]}]}

        _ ->
          {:., [], [outer, inner]}
      end
    end
  end

  defp combine_chain_ast_parts({:., [], [nil, part]}, inner) do
    {:., [], [nil, {:., [], [part, inner]}]}
  end

  defp combine_chain_ast_parts(outer, inner) do
    {:., [], [outer, inner]}
  end

  def chain_ast(rest, sections, context, _line, _offset) do
    sections = Enum.reduce(sections, &combine_chain_ast_parts/2)

    {rest, [sections], context}
  end

  def to_function_call_ast(rest, args, context, _line, _offset) do
    [ast_name | other_args] = Enum.reverse(args)

    {rest, [{String.to_atom(ast_name), [], other_args}], context}
  end

  def to_ime_function_call_ast(
        rest,
        [{Elixir, [], variable}],
        context,
        _line,
        _offset,
        _is_initial = true
      ) do
    {rest, [{:., [], [nil, {Elixir, [], {:to_ime, [], [variable]}}]}], context}
  end

  def to_ime_function_call_ast(
        rest,
        [{Elixir, [], variable}],
        context,
        _line,
        _offset,
        _is_initial = false
      ) do
    {rest, [{Elixir, [], {:to_ime, [], [variable]}}], context}
  end

  def to_keyword_tuple_ast(rest, [arg1, arg2], context, _line, _offset) do
    {rest, [{String.to_atom(arg2), arg1}], context}
  end

  def tag_as_content(rest, [content], context, _line, _offset) do
    {rest, [content: content], context}
  end

  def tag_as_content(rest, content, context, _line, _offset) do
    {rest, [content: Enum.reverse(content)], context}
  end

  def block_open_to_ast(rest, [class_name], context, _line, _offset) do
    {rest, [[class_name, {:_target, [], Elixir}]], context}
  end

  def block_open_to_ast(rest, [key_value_pairs, class_name], context, _line, _offset) do
    {rest, [[class_name, key_value_pairs]], context}
  end

  def event_to_ast(rest, [name], context, _line, _offset) do
    {rest, [{:__event__, [], [name, []]}], context}
  end

  def event_to_ast(rest, [opts, name], context, _line, _offset) do
    {rest, [{:__event__, [], [name, opts]}], context}
  end
end
