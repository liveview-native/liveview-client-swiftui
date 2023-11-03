defmodule LiveViewNative.SwiftUI.RulesParser.Tokens do
  import NimbleParsec
  import LiveViewNative.SwiftUI.RulesParser.Parser
  alias LiveViewNative.SwiftUI.RulesParser.PostProcessors

  def comment() do
    ignore_whitespace()
    |> string("#")
    |> concat(repeat_until(utf8_char([]), [?\n]))
    |> ignore()
  end

  def boolean() do
    choice([
      replace(string("true"), true),
      replace(string("false"), false)
    ])
  end

  def nil_(), do: replace(string("nil"), nil)

  def minus(), do: string("-")

  def underscored_integer() do
    integer(min: 1)
    |> repeat(
      choice([
        ascii_char([?0..?9]),
        ignore(string("_"))
        |> ascii_char([?0..?9])
      ])
      |> reduce({List, :to_string, []})
    )
    |> reduce({Enum, :join, [""]})
  end

  def integer() do
    optional(minus())
    |> concat(underscored_integer())
    |> reduce({Enum, :join, [""]})
    |> map({String, :to_integer, []})
  end

  def frac() do
    concat(string("."), underscored_integer())
  end

  def float() do
    integer()
    |> concat(frac())
    |> reduce({Enum, :join, [""]})
    |> map({String, :to_float, []})
  end

  def number() do
    choice([float(), integer()])
    |> expect(
      ignore_whitespace()
      |> utf8_char(String.to_charlist(".,)]"))
      |> ignore()
      |> lookahead(),
      error_message: "Invalid suffix on number",
      error_parser: non_whitespace(also_ignore: String.to_charlist(".,)]"))
    )
  end

  def atom() do
    ignore(string(":"))
    |> concat(
      choice([
        double_quoted_string(),
        variable_name()
      ])
      |> expect(
        error_message: "Expected an atom",
        error_parser:
          choice([
            non_whitespace(also_ignore: String.to_charlist("[](),"), fail_if_empty: true),
            non_whitespace(also_ignore: String.to_charlist("]),"), fail_if_empty: true),
            non_whitespace()
          ]),
        show_incorrect_text?: true
      )
    )
    |> map({String, :to_atom, []})
  end

  def double_quoted_string() do
    ignore(string(~s(")))
    |> repeat(
      lookahead_not(ascii_char([?"]))
      |> choice([string(~s(\")), utf8_char([])])
    )
    |> ignore(string(~s(")))
    |> reduce({List, :to_string, []})
  end

  #
  # Whitespace
  #

  def whitespace(opts) do
    utf8_string([?\s, ?\n, ?\r, ?\t], opts)
  end

  def whitespace_except(exception, opts) do
    utf8_string(Enum.reject([?\s, ?\n, ?\r, ?\t], &(<<&1>> == exception)), opts)
  end

  def ignore_whitespace(combinator \\ empty()) do
    combinator |> ignore(optional(whitespace(min: 1)))
  end

  # @tuple_children [
  #   parsec(:nested_attribute),
  #   atom(),
  #   boolean,
  #   variable(),
  #   string()
  # ]

  # def tuple() do
  #   ignore_whitespace()
  #   |> ignore(string("{"))
  #   |> comma_separated_list(choice(@tuple_children))
  #   |> ignore(string("}"))
  #   |> ignore_whitespace()
  #   |> wrap()
  # end

  #
  # AST
  #

  def literal(opts \\ []) do
    one_of(
      [
        {number(), "number"},
        {double_quoted_string(), "string"},
        {nil_(), "nil"},
        {boolean(), "boolean"},
        {atom(), "atom"}
      ],
      Keyword.merge(opts, show_incorrect_text?: true)
    )
  end

  def word() do
    ascii_string([?a..?z, ?A..?Z, ?0..?9, ?_], min: 1)
  end

  def variable_name() do
    ascii_string([?a..?z, ?A..?Z, ?_], 1)
    |> ascii_string([?a..?z, ?A..?Z, ?0..?9, ?_], min: 0)
    |> reduce({Enum, :join, [""]})
  end

  def variable(opts \\ []) do
    variable_name()
    |> post_traverse({PostProcessors, :to_elixir_variable_ast, []})
    |> expect(
      Keyword.merge(
        opts,
        error_message: "expected a variable"
      )
    )
  end

  def modifier_name() do
    ascii_string([?a..?z, ?A..?Z, ?_], 1)
    |> ascii_string([?a..?z, ?A..?Z, ?0..?9, ?_], min: 0)
    |> reduce({Enum, :join, [""]})
    |> expect(
      error_message: "Expected a modifier name",
      error_parser:
        choice([
          non_whitespace(also_ignore: String.to_charlist("[](),"), fail_if_empty: true),
          non_whitespace(also_ignore: String.to_charlist("]),"), fail_if_empty: true),
          non_whitespace()
        ]),
      show_incorrect_text?: true
    )
    |> reject_if_in(
      ["event", "attr"],
      &__MODULE__.modifier_name_error/1
    )
  end

  def modifier_name_error("event") do
    ~s'‘event’ can only be used as an argument to a modifier eg ‘searchable(change: event("search-event", throttle: 10_000))’'
  end

  def modifier_name_error("attr") do
    ~s'‘attr’ can only be used as an argument to a modifier eg ‘attr("placeholder")’'
  end

  def modifier_name_error(matched) do
    ~s'‘#{matched}’ can only be used as an argument to a modifier'
  end

  def type_name(opts \\ []) do
    ascii_string([?A..?Z], 1)
    |> ascii_string([?a..?z, ?A..?Z, ?0..?9, ?_], min: 0)
    |> reduce({Enum, :join, [""]})
    |> expect(
      Keyword.merge(opts,
        error_message: "Expected a type name",
        error_parser:
          choice([
            non_whitespace(also_ignore: String.to_charlist("[](),"), fail_if_empty: true),
            non_whitespace(also_ignore: String.to_charlist("]),"), fail_if_empty: true),
            non_whitespace()
          ]),
        show_incorrect_text?: true
      )
    )
  end
end
