defmodule LiveViewNative.SwiftUI.RulesParser.Expressions do
  import NimbleParsec
  import LiveViewNative.SwiftUI.RulesParser.Parser
  import LiveViewNative.SwiftUI.RulesParser.Tokens
  alias LiveViewNative.SwiftUI.RulesParser.PostProcessors

  def enclosed(start \\ empty(), open, combinator, close, opts) do
    allow_empty? = Keyword.get(opts, :allow_empty?, true)

    close =
      expect(
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

  def comma_separated_list(elem_combinator, opts \\ []) do
    delimiter_separated_list(
      empty(),
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

  def key_value_pair(opts \\ []) do
    key =
      if opts[:generate_error?] || false do
        # require that the colon be provided
        concat(
          word(),
          expect(ignore(string(":")), error_message: "expected ‘:’")
        )
      else
        concat(word(), ignore(string(":")))
      end

    value = parsec(:key_value_pairs_arguments)

    ignore_whitespace()
    |> concat(key)
    |> ignore(whitespace(min: 1))
    |> concat(value)
    |> post_traverse({PostProcessors, :to_keyword_tuple_ast, []})
  end

  def key_value_pairs(opts \\ []) do
    wrap(comma_separated_list(key_value_pair(opts), opts))
  end
end
