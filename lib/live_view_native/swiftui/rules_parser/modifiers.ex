defmodule LiveViewNative.SwiftUI.RulesParser.Modifiers do
  import NimbleParsec
  import LiveViewNative.SwiftUI.RulesParser.Tokens
  import LiveViewNative.SwiftUI.RulesParser.Expressions
  import LiveViewNative.SwiftUI.RulesParser.Parser
  alias LiveViewNative.SwiftUI.RulesParser.PostProcessors
  import LiveViewNative.SwiftUI.RulesHelpers

  defcombinator(
    :key_value_list,
    enclosed("[", key_value_pairs(generate_error?: false, allow_empty?: false), "]",
      allow_empty?: false,
      error_parser: non_whitespace(also_ignore: String.to_charlist(")],"))
    )
  )

  modifier_brackets = fn opts ->
    is_nested = Keyword.get(opts, :nested, true)

    combinator =
      choice([
        ignore(
          string("(")
          |> ignore_whitespace()
          |> string(")")
        ),
        enclosed("(", parsec(:modifier_arguments), ")", allow_empty?: false)
      ])

    if is_nested do
      combinator
    else
      expected(combinator,
        error_message:
          """
          Expected ‘()’ or ‘(<modifier_arguments>)’ where <modifier_arguments> are a comma separated list of:
          #{label_from_named_choices(@modifier_arguments)}
          """
          |> String.trim()
      )
    end
  end

  dotted_ime = fn is_initial ->
    ignore(string("."))
    |> concat(word())
    |> wrap(
      choice([
        ignore(string("()")),
        lookahead(utf8_char(String.to_charlist(".)")))
        |> concat(empty()),
        modifier_brackets.(nested: true)
      ])
    )
    |> post_traverse({PostProcessors, :to_dotted_ime_ast, [is_initial]})
  end

  ime_function = fn is_initial ->
    if is_initial do
      empty()
    else
      ignore(string("."))
    end
    |> ignore(string("to_ime"))
    |> enclosed(
      "(",
      variable(
        force_error?: true,
        error_message: "Expected a variable",
        error_parser: non_whitespace(also_ignore: String.to_charlist(")"))
      )
      |> post_traverse({PostProcessors, :to_ime_function_call_ast, [is_initial]}),
      ")",
      []
    )
  end

  scoped_ime =
    module_name()
    |> choice([
      ime_function.(false),
      dotted_ime.(false)
    ])
    |> post_traverse({PostProcessors, :to_scoped_ime_ast, []})

  defparsec(
    :ime,
    start()
    |> choice([
      # Scoped
      # Color.red
      scoped_ime,
      # to_ime(color)
      ime_function.(true),
      # Implicit
      # .red
      dotted_ime.(true)
    ])
    # scoped_ime
    |> repeat(
      choice([
        # <other_ime>.to_ime(color)
        ime_function.(false),
        # <other_ime>.red
        dotted_ime.(false)
      ])
    )
    |> post_traverse({PostProcessors, :chain_ast, []})
  )

  defcombinator(
    :attr,
    string("attr")
    |> enclosed(
      "(",
      expected(
        double_quoted_string(),
        error_message: "attr expects a string argument"
      ),
      ")",
      []
    )
    |> post_traverse({PostProcessors, :to_attr_ast, []})
  )

  # TODO: Errors
  defparsec(
    :event,
    ignore(string("event"))
    |> enclosed(
      "(",
      double_quoted_string()
      |> optional(
        ignore_whitespace()
        |> ignore(string(","))
        |> ignore_whitespace()
        |> concat(key_value_pairs())
      ),
      ")",
      []
    )
    |> post_traverse({PostProcessors, :event_to_ast, []})
  )

  @modifier_arguments [
    {
      literal(error_parser: empty(), generate_error?: false),
      ~s'a number, string, nil, boolean or :atom'
    },
    {
      parsec(:event),
      ~s'event'
    },
    {
      parsec(:attr),
      ~s'attr'
    },
    {parsec(:ime), ~s'an IME eg ‘Color.red’ or ‘.largeTitle’ or ‘Color.to_ime(variable)’'},
    {
      key_value_pairs(generate_error?: false, allow_empty?: false),
      ~s'a list of keyword pairs eg ‘style: :dashed’, ‘size: 12’ or  ‘style: [lineWidth: 1]’'
    },
    {
      parsec(:helper_function),
      ~s'attr'
    },
    # {SwiftClass.HelperFunctions.helper_function(), "a helper function eg ‘to_float(number)"},

    # {parsec(:nested_attribute), ~s'a modifier eg ‘foo(bar())’'},
    {
      frozen(parsec(:nested_modifier)),
      "a modifier eg ‘bold()’"
    },
    {
      variable(generate_error?: false),
      ~s|a variable defined in the class header eg ‘color_name’|
    }
  ]

  defcombinator(
    :modifier_arguments,
    empty()
    |> comma_separated_list(
      one_of(empty(), @modifier_arguments,
        error_parser: non_whitespace(also_ignore: String.to_charlist(")"))
      ),
      allow_empty?: false,
      error_message:
        """
        Expected ‘(<modifier_arguments>)’ where <modifier_arguments> are a comma separated list of:
        #{label_from_named_choices(@modifier_arguments)}
        """
        |> String.trim(),
      error_parser: non_whitespace(also_ignore: String.to_charlist(")]"))
    )
  )

  defparsec(
    :nested_modifier,
    ignore_whitespace()
    |> concat(modifier_name())
    |> concat(modifier_brackets.(nested: true))
    |> post_traverse({PostProcessors, :to_function_call_ast, []})
  )

  defparsec(
    :modifier,
    ignore_whitespace()
    |> concat(modifier_name())
    |> concat(modifier_brackets.(nested: false))
    |> post_traverse({PostProcessors, :to_function_call_ast, []}),
    export_combinator: true
  )

  defparsec(
    :modifiers,
    start()
    |> repeat(parsec(:modifier))
    |> ignore_whitespace()
    |> eos(),
    export_combinator: true
  )
end
