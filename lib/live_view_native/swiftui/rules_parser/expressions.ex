defmodule LiveViewNative.SwiftUI.RulesParser.Expressions do
  import NimbleParsec
  import LiveViewNative.SwiftUI.RulesParser.Parser
  import LiveViewNative.SwiftUI.RulesParser.Tokens
  alias LiveViewNative.SwiftUI.RulesParser.PostProcessors

  def enclosed(start \\ empty(), open, combinator, close, opts) do
    allow_empty? = Keyword.get(opts, :allow_empty?, true)

    close =
      expected(
        ignore(string(close)),
        error_message: "expected ‘#{close}’",
        error_parser: optional(non_whitespace(also_ignore: String.to_charlist(close)))
      )

    start
    |> ignore(string(open))
    |> ignore_whitespace()
    |> concat(
      if allow_empty? do
        optional2(combinator)
      else
        combinator
      end
    )
    |> ignore_whitespace()
    |> concat(close)
  end

  #
  # Collections
  #

  def comma_separated_list(start \\ empty(), elem_combinator, opts \\ []) do
    delimiter_separated_list(
      start,
      elem_combinator,
      ",",
      Keyword.merge([allow_empty?: true], opts)
    )
  end

  defp delimiter_separated_list(combinator, elem_combinator, delimiter, opts) do
    allow_empty? = Keyword.get(opts, :allow_empty?, true)

    #  1+ elems
    non_empty =
      elem_combinator
      |> repeat(
        ignore_whitespace()
        |> ignore(string(delimiter))
        |> ignore_whitespace()
        |> concat(elem_combinator)
      )

    if allow_empty? do
      combinator
      |> optional2(non_empty)
    else
      combinator
      |> concat(non_empty)
    end
  end

  def key_value_children(generate_error?) do
    [
      {literal(error_parser: empty(), generate_error?: generate_error?),
       ~s'a number, string, nil, boolean or atom'},
      {parsec(:key_value_list),
       ~s'a keyword list eg ‘[style: :dashed]’, ‘[size: 12]’ or ‘[lineWidth: lineWidth]’'},
      {parsec(:ime), ~s'an IME eg ‘Color.red’ or ‘.largeTitle’ or ‘Color.to_ime(variable)’'},
      {parsec(:modifier_arguments), ~s'a modifier eg ‘foo(bar())’'},
      {variable(generate_error?: generate_error?),
       ~s|a variable defined in the class header eg ‘color_name’|}
    ]
  end

  def key_value_pair() do
    key = concat(word(), ignore(string(":")))

    value =
      one_of(
        key_value_children(false),
        error_parser: non_whitespace(also_ignore: String.to_charlist(")],"))
      )

    ignore_whitespace()
    |> concat(key)
    |> ignore(whitespace(min: 1))
    |> concat(value)
    |> post_traverse({PostProcessors, :to_keyword_tuple_ast, []})
  end

  def key_value_pairs(opts \\ []) do
    empty()
    |> comma_separated_list(key_value_pair(), opts)
    |> wrap()
  end

end
