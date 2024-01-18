defmodule LiveViewNative.SwiftUI.RulesParser.Expressions do
  import NimbleParsec
  import LiveViewNative.SwiftUI.RulesParser.Parser
  import LiveViewNative.SwiftUI.RulesParser.Tokens
  alias LiveViewNative.SwiftUI.RulesParser.PostProcessors

  def enclosed(start \\ empty(), open, combinator, close, opts) do
    allow_empty? = Keyword.get(opts, :allow_empty?, true)
    generate_error? = Keyword.get(opts, :generate_error?, true)

    close =
      expect(
        ignore(string(close)),
        error_message: "expected ‘#{close}’",
        generate_error?: generate_error?,
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

  def seq(combinators) do
    Enum.reduce(combinators, empty(), &concat(&2, &1))
  end

  defp swift_range(combinator) do
    nil_ = replace(empty(), nil)

    choice([
      # foo(Foo.bar...Baz.qux)
      seq([combinator, string("..."), combinator]),
      # foo(Foo.bar...)
      seq([combinator, string("..."), nil_]),
      # foo(...Baz.qux)
      seq([nil_, string("..."), combinator]),
      # foo(Foo.bar..<Baz.qux)
      seq([combinator, string("..<"), combinator]),
      # foo(..<Baz.qux)
      seq([nil_, string("..<"), combinator])
    ])
    |> post_traverse({PostProcessors, :to_swift_range_ast, []})
  end

  def swift_range() do
    scoped_atom =
      type_name(generate_error?: false)
      |> ignore(string("."))
      |> concat(word())
      |> post_traverse({PostProcessors, :to_scoped_atom, []})

    choice([
      swift_range(scoped_atom),
      swift_range(integer()),
      swift_range(double_quoted_string())
    ])
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
    colon =
      if opts[:generate_error?] do
        # require that the colon be provided
        expect(ignore(string(":")), error_message: "expected ‘:’")
      else
        ignore(string(":"))
      end

    key = concat(word(), colon)
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
