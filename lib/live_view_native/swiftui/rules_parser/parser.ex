defmodule LiveViewNative.SwiftUI.RulesParser.Parser do
  import NimbleParsec
  alias LiveViewNative.SwiftUI.RulesParser.Parser.Context
  alias LiveViewNative.SwiftUI.RulesParser.Parser.Error

  def start() do
    pre_traverse(empty(), {Context, :prepare_context, []})
  end

  def label_from_named_choices(named_choices) do
    {_, names} = Enum.unzip(named_choices)

    names
    |> Enum.map(&(" - " <> &1))
    |> Enum.join("\n")
  end

  def one_of(combinator \\ empty(), named_choices, opts) do
    if not match?([_, _ | _], named_choices) do
      raise ArgumentError, "one_of expects two or more choices"
    end

    error_parser = Keyword.get(opts, :error_parser, non_whitespace())
    show_incorrect_text? = Keyword.get(opts, :show_incorrect_text?, false)
    generate_error? = Keyword.get(opts, :generate_error?, true)

    {choices, _} = Enum.unzip(named_choices)

    #
    choice(
      combinator,
      choices ++
        if generate_error? do
          [
            error_parser
            |> put_error(
              "Expected one of the following:\n" <>
                label_from_named_choices(named_choices) <> "\n",
              show_incorrect_text?: show_incorrect_text?
            )
          ]
        else
          []
        end
    )
  end

  def expect(combinator \\ empty(), combinator_2, opts) do
    error_parser = Keyword.get(opts, :error_parser, non_whitespace())
    error_message = Keyword.get(opts, :error_message)
    generate_error? = Keyword.get(opts, :generate_error?, true)

    combinator
    |> concat(
      if generate_error? do
        choice([
          combinator_2,
          put_error(error_parser, error_message, opts)
        ])
      else
        combinator_2
      end
    )
  end

  def optional2(combinator \\ empty(), combinator_2) do
    combinator
    |> post_traverse({Context, :freeze_context, []})
    |> optional(combinator_2)
    |> post_traverse({Context, :unfreeze_context, []})
  end

  def frozen(combinator \\ empty(), combinator_2) do
    combinator
    |> concat(combinator_2)
    |> pre_traverse({Context, :freeze_context, []})
    |> post_traverse({Context, :unfreeze_context, []})
  end

  def put_error(error_parser, error_message, opts \\ []) do
    post_traverse(error_parser, {Error, :put_error, [error_message, opts]})
  end

  def reject_if_in(parser, exceptions, error_message_fn) do
    post_traverse(parser, {__MODULE__, :__reject_if_in__, [exceptions, error_message_fn]})
  end

  def __reject_if_in__(rest, [arg], context, position, byte_offset, exceptions, error_message_fn) do
    if arg in exceptions do
      Error.put_error(rest, [arg], context, position, byte_offset, error_message_fn.(arg))
    else
      {rest, [arg], context}
    end
  end

  def __reject_if_in__(rest, args, context, _, _, _, _) do
    {rest, args, context}
  end

  @whitespace_chars [?\s, ?\t, ?\n, ?\r]

  def non_whitespace(opts \\ []) do
    also_ignore = Keyword.get(opts, :also_ignore, [])
    fail_if_empty = Keyword.get(opts, :fail_if_empty, false)

    repeat_until(utf8_char([]), @whitespace_chars ++ also_ignore)
    |> reduce({List, :to_string, []})
    |> post_traverse({__MODULE__, :delete_if_empty_string, []})
    |> post_traverse({__MODULE__, :fail_if_empty, [fail_if_empty]})
  end

  def delete_if_empty_string(rest, [""], context, _, _) do
    {rest, [], context}
  end

  def delete_if_empty_string(rest, args, context, _, _) do
    {rest, args, context}
  end

  def fail_if_empty(_, [], _, _, _, true) do
    {:error, "non_whitespace is empty"}
  end

  def fail_if_empty(rest, args, context, _, _, _) do
    {rest, args, context}
  end

  def repeat_until(combinator, matches) do
    repeat_while(combinator, {__MODULE__, :not_match, [matches]})
  end

  def not_match(<<char::utf8, _::binary>>, context, _, _, matches) do
    if char in matches do
      {:halt, context}
    else
      {:cont, context}
    end
  end

  def not_match("", context, _, _, _) do
    {:cont, context}
  end

  def error_from_result(result) do
    case result do
      {_, _output, rest, %{context: %Context{errors: [_ | _]} = context}, _position, _byte_offset} ->
        {message, position, byte_offset} = Error.context_to_error_message(context)
        {:error, message, rest, context, position, byte_offset}

      result ->
        result
    end
  end
end
