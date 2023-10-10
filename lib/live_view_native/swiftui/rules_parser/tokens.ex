defmodule LiveViewNative.SwiftUI.RulesParser.Tokens do
  import NimbleParsec

  #
  # Literals
  #

  def true_value() do
    string("true")
    |> replace(true)
  end

  def false_value() do
    string("false")
    |> replace(false)
  end

  def boolean() do
    choice([true_value(), false_value()])
  end

  def null(), do: replace(string("nil"), nil)

  def minus(), do: string("-")

  def plus(), do: string("+")

  def int() do
    optional(minus())
    |> concat(integer(min: 1))
    |> reduce({Enum, :join, [""]})
    |> map({String, :to_integer, []})
  end

  def frac() do
    concat(string("."), integer(min: 1))
  end

  def float() do
    int()
    |> concat(frac())
    |> reduce({Enum, :join, [""]})
    |> map({String, :to_float, []})
  end

  def atom() do
    ignore(string(":"))
    |> concat(word())
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

  def literal() do
    choice([
      float(),
      int(),
      boolean(),
      null(),
      atom(),
      double_quoted_string()
    ])
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

  def variable() do
    ascii_string([?a..?z, ?A..?Z, ?_], 1)
    |> ascii_string([?a..?z, ?A..?Z, ?0..?9, ?_], min: 1)
    |> reduce({Enum, :join, [""]})
    |> post_traverse({:to_elixir_variable_ast, []})
  end

  def word() do
    ascii_string([?a..?z, ?A..?Z, ?0..?9, ?_], min: 1)
  end

  def module_name() do
    ascii_string([?A..?Z], 1)
    |> ascii_string([?a..?z, ?A..?Z, ?0..?9, ?_], min: 0)
    |> reduce({Enum, :join, [""]})
  end

  def enclosed(start \\ empty(), open, combinator, close) do
    start
    |> ignore_whitespace()
    |> ignore(string(open))
    |> ignore_whitespace()
    |> concat(combinator)
    |> ignore_whitespace()
    |> ignore(string(close))
    |> ignore_whitespace()
  end

  #
  # Collections
  #

  def comma_separated_list(combinator \\ empty(), elem_combinator) do
    delimiter_separated_list(combinator, elem_combinator, ",", true)
  end

  def non_empty_comma_separated_list(combinator, elem_combinator) do
    delimiter_separated_list(combinator, elem_combinator, ",", false)
  end

  def delimiter_separated_list(combinator, elem_combinator, delimiter, allow_empty \\ true) do
    #  1+ elems
    non_empty =
      elem_combinator
      |> repeat(
        ignore_whitespace()
        |> ignore(string(delimiter))
        |> ignore_whitespace()
        |> concat(elem_combinator)
      )

    empty_ = ignore_whitespace(empty())

    if allow_empty do
      combinator
      |> choice([non_empty, empty_])
    else
      combinator
      |> concat(non_empty)
    end
  end

  def newline_separated_list(elem_combinator) do
    #  1+ elems
    ignore_whitespace()
    |> concat(elem_combinator)
    |> repeat(
      choice([
        ignore(optional(whitespace_except("\n", min: 1)))
        |> ignore(string("\n"))
        |> ignore(whitespace(min: 1))
        |> concat(elem_combinator),
        # Require at least one whitespace
        ignore(whitespace(min: 1))
      ])
    )
  end

  def key_value_pair() do
    ignore_whitespace()
    |> concat(word())
    |> concat(ignore(string(":")))
    |> ignore_whitespace()
    |> concat(
      choice([
        literal(),
        parsec(:attr),
        parsec(:ime),
        parsec(:helper_function),
        parsec(:nested_attribute),
        parsec(:key_value_list),
        variable()
      ])
    )
    |> post_traverse({:to_keyword_tuple_ast, []})
  end
end
