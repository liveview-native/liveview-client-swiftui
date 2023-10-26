defmodule LiveViewNative.SwiftUI.RulesParser.Tokens do
  import NimbleParsec
  import LiveViewNative.SwiftUI.RulesParser.Parser
  alias LiveViewNative.SwiftUI.RulesParser.PostProcessors

  #
  # Literals
  #

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

  def int() do
    optional(minus())
    |> concat(underscored_integer())
    |> reduce({Enum, :join, [""]})
    |> map({String, :to_integer, []})
  end

  def frac() do
    concat(string("."), underscored_integer())
  end

  def float() do
    int()
    |> concat(frac())
    |> reduce({Enum, :join, [""]})
    |> map({String, :to_float, []})
  end

  def atom() do
    ignore(string(":"))
    |> choice([
      double_quoted_string(),
      word()
    ])
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
      empty(),
      [
        {float(), "float"},
        {int(), "int"},
        {boolean(), "boolean"},
        {nil_(), "nil"},
        {atom(), "atom"},
        {double_quoted_string(), "string"}
      ],
      Keyword.merge([show_incorrect_text?: true], opts)
    )
  end

  def word() do
    ascii_string([?a..?z, ?A..?Z, ?0..?9, ?_], min: 1)
  end

  def variable(opts \\ []) do
    expected(
      ascii_string([?a..?z, ?A..?Z, ?_], 1)
      |> ascii_string([?a..?z, ?A..?Z, ?0..?9, ?_], min: 0)
      |> reduce({Enum, :join, [""]})
      |> post_traverse({PostProcessors, :to_elixir_variable_ast, []}),
      Keyword.merge(
        [error_message: "expected a variable"],
        opts
      )
    )
  end

  def modifier_name() do
    expected(
      ascii_string([?a..?z, ?A..?Z, ?_], 1)
      |> ascii_string([?a..?z, ?A..?Z, ?0..?9, ?_], min: 0)
      |> reduce({Enum, :join, [""]}),
      error_message: "Expected a modifier name",
      error_parser:
        choice([
          non_whitespace(also_ignore: String.to_charlist("[](),"), fail_if_empty: true),
          non_whitespace(also_ignore: String.to_charlist("]),"), fail_if_empty: true),
          non_whitespace()
        ]),
      show_incorrect_text?: true
    )
  end

  def module_name() do
    expected(
      ascii_string([?A..?Z], 1)
      |> ascii_string([?a..?z, ?A..?Z, ?0..?9, ?_], min: 0)
      |> reduce({Enum, :join, [""]}),
      error_message: "Expected a module name",
      error_parser:
        choice([
          non_whitespace(also_ignore: String.to_charlist("[](),"), fail_if_empty: true),
          non_whitespace(also_ignore: String.to_charlist("]),"), fail_if_empty: true),
          non_whitespace()
        ]),
      show_incorrect_text?: true
    )
  end
end
