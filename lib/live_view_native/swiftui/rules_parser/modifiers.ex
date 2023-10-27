defmodule LiveViewNative.SwiftUI.RulesParser.Modifiers do
  import NimbleParsec
  import LiveViewNative.SwiftUI.RulesParser.Tokens
  import LiveViewNative.SwiftUI.RulesParser.Expressions
  import LiveViewNative.SwiftUI.RulesParser.Parser
  alias LiveViewNative.SwiftUI.RulesParser.PostProcessors
  import LiveViewNative.SwiftUI.RulesHelpers

  defcombinator(
    :key_value_list,
    enclosed("[", key_value_pairs(generate_error?: true, allow_empty?: false), "]",
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
      expect(combinator,
        error_message:
          """
          Expected ‘()’ or ‘(<modifier_arguments>)’ where <modifier_arguments> are a comma separated list of:
          #{label_from_named_choices(@modifier_arguments.(false))}
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
        # Exit the ime if it does not have arguments
        lookahead_not(utf8_char(String.to_charlist("(")))
        |> concat(empty()),
        # Otherwise, parse the arguments
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
    type_name()
    |> choice([
      ime_function.(false),
      dotted_ime.(false)
    ])
    |> post_traverse({PostProcessors, :to_scoped_ime_ast, []})

  defparsecp(
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
    start()
    |> string("attr")
    |> enclosed(
      "(",
      expect(
        double_quoted_string(),
        error_message: "‘attr’ expects a string argument",
        error_parser: optional(non_whitespace(also_ignore: String.to_charlist(")],")))
      ),
      ")",
      allow_empty?: false
    )
    |> post_traverse({PostProcessors, :to_attr_ast, []})
  )

  event_arg_1 =
    expect(
      double_quoted_string(),
      error_message: "‘event’ expects a string as the first argument",
      error_parser: optional(non_whitespace(also_ignore: String.to_charlist(")],")))
    )

  event_arg_2 =
    ignore_whitespace()
    |> ignore(string(","))
    |> ignore_whitespace()
    |> concat(
      expect(
        choice([
          ignore(enclosed("[", ignore_whitespace(), "]", [])),
          parsec(:key_value_list),
          key_value_pairs(allow_empty?: false)
        ]),
        error_message: "‘event’ expects a keyword list as the second argument",
        error_parser: optional(non_whitespace(also_ignore: String.to_charlist(")],")))
      )
    )

  maybe_event_arg_2 =
    choice([
      lookahead(ignore_whitespace(), string(")")),
      event_arg_2
    ])

  defparsecp(
    :event,
    ignore(string("event"))
    |> enclosed("(", concat(event_arg_1, maybe_event_arg_2), ")", allow_empty?: false)
    |> post_traverse({PostProcessors, :event_to_ast, []})
  )

  @modifier_arguments fn inside_key_value_pair? ->
    [
      {
        parsec(:key_value_list),
        ~s'a keyword list eg ‘[style: :dashed]’, ‘[size: 12]’ or ‘[lineWidth: lineWidth]’',
        inside_key_value_pair?
      },
      {
        literal(error_parser: empty(), generate_error?: false),
        ~s'a number, string, nil, boolean or :atom'
      },
      {
        parsec(:event),
        ~s'an event eg ‘event("search-event", throttle: 10_000)’'
      },
      {
        parsec(:attr),
        ~s'an attribute eg ‘attr("placeholder")’'
      },
      {
        parsec(:ime),
        ~s'an IME eg ‘Color.red’ or ‘.largeTitle’ or ‘Color.to_ime(variable)’'
      },
      {
        key_value_pairs(generate_error?: false, allow_empty?: false),
        ~s'a list of keyword pairs eg ‘style: :dashed’, ‘size: 12’ or  ‘style: [lineWidth: 1]’',
        not inside_key_value_pair?
      },
      {
        parsec(:helper_function),
        ~s'a helper function eg ‘to_float(variable)’'
      },
      {
        frozen(parsec(:nested_modifier)),
        "a modifier eg ‘bold()’"
      },
      {
        variable(generate_error?: false),
        ~s'a variable defined in the class header eg ‘color_name’'
      }
    ]
    |> Enum.flat_map(fn
      {combinator, description} -> [{combinator, description}]
      {combinator, description, true} -> [{combinator, description}]
      {_, _, false} -> []
    end)
  end

  defcombinator(
    :key_value_pairs_arguments,
    one_of(
      @modifier_arguments.(true),
      error_parser: non_whitespace(also_ignore: String.to_charlist(")"))
    )
  )

  defcombinator(
    :modifier_argument,
    one_of(@modifier_arguments.(false),
      error_parser: non_whitespace(also_ignore: String.to_charlist(")"))
    )
  )

  defcombinator(
    :modifier_arguments,
    comma_separated_list(
      parsec(:modifier_argument),
      allow_empty?: false,
      error_message:
        """
        Expected ‘(<modifier_arguments>)’ where <modifier_arguments> are a comma separated list of:
        #{label_from_named_choices(@modifier_arguments.(false))}
        """
        |> String.trim(),
      error_parser: non_whitespace(also_ignore: String.to_charlist(")]"))
    )
  )

  defparsecp(
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
    |> repeat(
      choice([
        comment(),
        parsec(:modifier)
      ])
    )
    |> ignore_whitespace()
    |> eos(),
    export_combinator: true
  )
end
