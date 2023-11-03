defmodule LiveViewNative.SwiftUI.RulesParser.PostProcessors do
  import LiveViewNative.SwiftUI.RulesParser.Parser.Annotations

  def to_attr_ast(rest, [attr, "attr"], context, {line, _}, _byte_offset) when is_binary(attr) do
    {rest, [{:__attr__, context_to_annotation(context.context, line), attr}], context}
  end

  def wrap_in_tuple(rest, args, context, {_line, _}, _byte_offset) do
    {rest, [List.to_tuple(Enum.reverse(args))], context}
  end

  def block_open_with_variable_to_ast(rest, [variable, string], context, {line, _}, _byte_offset) do
    {rest,
     [
       {:<>,
        context_to_annotation(context.context, line) ++ [context: Elixir, imports: [{2, Kernel}]],
        [string, variable]}
     ], context}
  end

  def tag_as_elixir_code(rest, [quotable], context, {line, _}, _byte_offset) do
    {rest,
     [
       {Elixir, context_to_annotation(context.context, line), quotable}
     ], context}
  end

  def to_elixir_variable_ast(rest, [variable_name], context, {line, _}, _byte_offset) do
    {rest,
     [
       {Elixir, context_to_annotation(context.context, line),
        {String.to_atom(variable_name), context_to_annotation(context.context, line), Elixir}}
     ], context}
  end

  def to_dotted_ime_ast(
        rest,
        [[], variable_name],
        context,
        {line, _},
        _offset,
        _is_initial = true
      ) do
    {rest,
     [{:., context_to_annotation(context.context, line), [nil, String.to_atom(variable_name)]}],
     context}
  end

  def to_dotted_ime_ast(
        rest,
        [args, variable_name],
        context,
        {line, _},
        _offset,
        _is_initial = true
      ) do
    {rest,
     [
       {:., context_to_annotation(context.context, line),
        [nil, {String.to_atom(variable_name), context_to_annotation(context.context, line), args}]}
     ], context}
  end

  def to_dotted_ime_ast(rest, [[], variable_name], context, {_line, _}, _offset, false) do
    {rest, [String.to_atom(variable_name)], context}
  end

  def to_dotted_ime_ast(rest, [args, variable_name], context, {line, _}, _offset, false) do
    {rest, [{String.to_atom(variable_name), context_to_annotation(context.context, line), args}],
     context}
  end

  def to_scoped_ime_ast(rest, [[] = _args, variable_name, scope], context, _, _byte_offset) do
    {rest, [String.to_atom(variable_name), String.to_atom(scope)], context}
  end

  def to_scoped_ime_ast(rest, [args, variable_name, scope], context, {line, _}, _byte_offset) do
    annotations = context_to_annotation(context.context, line)

    {rest, [{String.to_atom(variable_name), annotations, args}, String.to_atom(scope)], context}
  end

  def to_scoped_ime_ast(rest, [[nil, variable], scope], context, {_line, _}, _byte_offset) do
    {rest, [variable, String.to_atom(scope)], context}
  end

  def to_scoped_ime_ast(rest, [variable, scope], context, {_line, _}, _byte_offset) do
    {rest, [variable, String.to_atom(scope)], context}
  end

  defp combine_chain_ast_parts(outer, inner) when is_atom(outer) do
    if Regex.match?(~r/^[A-Z]/, Atom.to_string(outer)) do
      {:., [], [outer, inner]}
    else
      case outer do
        {:., annotations, [nil, part]} ->
          {:., annotations, [nil, {:., annotations, [part, inner]}]}

        _ ->
          {:., [], [outer, inner]}
      end
    end
  end

  defp combine_chain_ast_parts({:., annotations, [nil, part]}, inner) do
    {:., annotations, [nil, {:., annotations, [part, inner]}]}
  end

  defp combine_chain_ast_parts(outer, inner) do
    {:., [], [outer, inner]}
  end

  def chain_ast(rest, sections, context, {_line, _}, _byte_offset) do
    sections = Enum.reduce(sections, &combine_chain_ast_parts/2)

    {rest, [sections], context}
  end

  def to_function_call_ast(rest, args, context, {line, _}, _byte_offset) do
    [ast_name | other_args] = Enum.reverse(args)
    annotations = context_to_annotation(context.context, line)

    {rest, [{String.to_atom(ast_name), annotations, other_args}], context}
  end

  def to_ime_function_call_ast(
        rest,
        [{Elixir, variable_annotations, variable}],
        context,
        {line, _},
        _offset,
        _is_initial = true
      ) do
    annotations = context_to_annotation(context.context, line)

    {rest,
     [
       {:., annotations,
        [nil, {Elixir, annotations, {:to_atom, variable_annotations, [variable]}}]}
     ], context}
  end

  def to_ime_function_call_ast(
        rest,
        [{Elixir, variable_annotations, variable}],
        context,
        {line, _},
        _offset,
        _is_initial = false
      ) do
    annotations = context_to_annotation(context.context, line)
    {rest, [{Elixir, annotations, {:to_atom, variable_annotations, [variable]}}], context}
  end

  def to_keyword_tuple_ast(rest, [arg1, arg2], context, {_line, _}, _byte_offset) do
    {rest, [{String.to_atom(arg2), arg1}], context}
  end

  # Ignore error case
  def to_keyword_tuple_ast(rest, _, context, {_line, _}, _byte_offset) do
    {rest, [], context}
  end

  def tag_as_content(rest, [content], context, {_line, _}, _byte_offset) do
    {rest, [content: content], context}
  end

  def tag_as_content(rest, content, context, {_line, _}, _byte_offset) do
    {rest, [content: Enum.reverse(content)], context}
  end

  def event_to_ast(rest, [name], context, {line, _}, _byte_offset) do
    annotations = context_to_annotation(context.context, line)

    {rest, [{:__event__, annotations, [name, []]}], context}
  end

  def event_to_ast(rest, [opts, name], context, {line, _}, _byte_offset) do
    annotations = context_to_annotation(context.context, line)
    {rest, [{:__event__, annotations, [name, opts]}], context}
  end

  def to_scoped_atom(rest, [variable_name, scope], context, {line, _}, _byte_offset) do
    annotations = context_to_annotation(context.context, line)
    {rest, [{:., annotations, [String.to_atom(scope), String.to_atom(variable_name)]}], context}
  end

  def to_swift_range_ast(rest, [end_, range, start], context, {line, _}, _byte_offset) do
    annotations = context_to_annotation(context.context, line)
    {rest, [{String.to_atom(range), annotations, [start, end_]}], context}
  end
end
