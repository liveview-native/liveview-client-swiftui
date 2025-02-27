defmodule LiveViewNative.SwiftUI.RulesParser.PostProcessors do
  @moduledoc false

  import LiveViewNative.SwiftUI.RulesParser.Parser.Annotations

  if Mix.env() == :test do
    @doc """
    You can view the input/output of any compinator by doing
      empty()
      |> PostProcessors.inspect()
      |> combinator
      |> PostProcessors.inspect(label: "combinator")
    This function is extremely useful for debugging, do not remove
    """
    def inspect(combinator, opts \\ []) do
      NimbleParsec.pre_traverse(
        combinator,
        {__MODULE__, :do_inspect, [opts]}
      )
    end

    def do_inspect(rest, args, context, position, _byte_offset, opts) do
      IO.inspect({rest, args, context, position}, opts)
      {rest, args, context}
    end
  end

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
        {String.to_atom(variable_name), context_to_annotation(context.context, line),
         context.variable_context}}
     ], context}
  end

  def to_dotted_ime_ast(rest, [args, variable_name], context, {line, _}, _offset, is_initial) do
    ime =
      if args == [] do
        String.to_atom(variable_name)
      else
        {String.to_atom(variable_name), context_to_annotation(context.context, line), args}
      end

    wrapped_ime =
      if is_initial do
        [{:., context_to_annotation(context.context, line), [nil, ime]}]
      else
        [ime]
      end

    {rest, wrapped_ime, context}
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
      {:., [], [inner, outer]}
    else
      case outer do
        {:., annotations, [nil, part]} ->
          {:., annotations, [{:., annotations, [nil, inner]}, part]}

        _ ->
          {:., [], [inner, outer]}
      end
    end
  end

  defp combine_chain_ast_parts({:., annotations, [nil, part]}, inner) do
    {:., annotations, [{:., annotations, [nil, inner]}, part]}
  end

  defp combine_chain_ast_parts(outer, inner) do
    {:., [], [inner, outer]}
  end

  def chain_ast(rest, sections, context, {_line, _}, _byte_offset) do
    sections =
      sections
      |> Enum.reverse()
      |> Enum.reduce(&combine_chain_ast_parts/2)

    {rest, [sections], context}
  end

  def to_function_call_ast(rest, args, context, {line, _}, _byte_offset) do
    [ast_name | other_args] = Enum.reverse(args)
    annotations = context_to_annotation(context.context, line)

    {rest, [{String.to_atom(ast_name), annotations, other_args}], context}
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

    {rest, [{:__event__, annotations, [name]}], context}
  end

  def event_to_ast(rest, [opts, name], context, {line, _}, _byte_offset) do
    annotations = context_to_annotation(context.context, line)
    {rest, [{:__event__, annotations, [name] ++ List.wrap(opts)}], context}
  end

  def add_annotations(rest, parts, context, {line, _}, _byte_offset) do
    annotations = context_to_annotation(context.context, line)
    {rest, [annotations | parts], context}
  end

  def to_scoped_atom(rest, [variable_name, scope], context, {line, _}, _byte_offset) do
    annotations = context_to_annotation(context.context, line)
    {rest, [{:., annotations, [String.to_atom(scope), String.to_atom(variable_name)]}], context}
  end

  def to_atom_ast(rest, [atom_str], context, {line, _}, _byte_offset) do
    {rest, [{:":", context_to_annotation(context.context, line), atom_str}], context}
  end

  def to_swift_range_ast(rest, [end_, range, start], context, {line, _}, _byte_offset) do
    annotations = context_to_annotation(context.context, line)
    {rest, [{String.to_atom(range), annotations, [start, end_]}], context}
  end
end
