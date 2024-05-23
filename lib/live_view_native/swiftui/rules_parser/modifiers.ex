defmodule LiveViewNative.SwiftUI.RulesParser.Modifiers do
  @moduledoc false

  import NimbleParsec
  import LiveViewNative.SwiftUI.RulesParser.Tokens
  import LiveViewNative.SwiftUI.RulesParser.Expressions
  import LiveViewNative.SwiftUI.RulesParser.Parser
  alias LiveViewNative.SwiftUI.RulesParser.PostProcessors

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

  scoped_ime =
    type_name()
    |> concat(dotted_ime.(false))
    |> post_traverse({PostProcessors, :to_scoped_ime_ast, []})

  defparsecp(
    :ime1,
    start()
    |> choice([
      # Scoped
      # Color.red
      scoped_ime,
      # Implicit
      # .red
      dotted_ime.(true)
    ])
    # scoped_ime
    |> repeat(
      # <other_ime>.red
      dotted_ime.(false)
    )
    |> post_traverse({PostProcessors, :chain_ast, []})
  )

  defparsecp(
    :ime2,
    # Color(.displayP3, red: 0.4627, green: 0.8392, blue: 1.0)
    parsec(:nested_modifier)
    |> times(
      # <other_ime>.red
      dotted_ime.(false),
      min: 1
    )
    |> post_traverse({PostProcessors, :chain_ast, []})
  )

  defparsecp(
    :ime,
    choice([
      parsec(:ime1),
      parsec(:ime2)
    ])
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

  defparsecp(
    :gesture_state,
    string("gesture_state")
    |> replace(:__gesture_state__)
    |> post_traverse({PostProcessors, :add_annotations, []})
    |> concat(wrap(modifier_brackets.(nested: true)))
    |> post_traverse({PostProcessors, :wrap_in_tuple, []})
  )

  @modifier_arguments fn inside_key_value_pair? ->
    [
      {
        parsec(:non_kv_list),
        ~s'a list of values eg ‘[1, 2, 3]’, ‘["red", "blue"]’ or ‘[Color.red, Color.blue]’'
      },
      {
        parsec(:key_value_list),
        ~s'a keyword list eg ‘[style: :dashed]’, ‘[size: 12]’ or ‘[lineWidth: lineWidth]’',
        inside_key_value_pair?
      },
      {
        swift_range(),
        ~s'a Swift range eg ‘1..<10’ or ‘foo(Foo.bar...Baz.qux)’'
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
        parsec(:gesture_state),
        nil
      },
      {
        parsec(:attr),
        ~s'an attribute eg ‘attr("placeholder")’'
      },
      {
        parsec(:ime),
        ~s'an IME eg ‘Color.red’ or ‘.largeTitle’’'
      },
      {
        key_value_pairs(generate_error?: false, allow_empty?: false),
        ~s'a list of keyword pairs eg ‘style: :dashed’, ‘size: 12’ or  ‘style: [lineWidth: 1]’',
        not inside_key_value_pair?
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
    :non_kv_list,
    enclosed(
      "[",
      comma_separated_list(
        one_of(
          @modifier_arguments.(true),
          error_parser: non_whitespace(also_ignore: String.to_charlist(")"))
        ),
        generate_error?: false,
        allow_empty?: true
      ),
      "]",
      allow_empty?: true,
      generate_error?: false,
      error_parser: non_whitespace(also_ignore: String.to_charlist(")],"))
    )
    |> wrap()
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
