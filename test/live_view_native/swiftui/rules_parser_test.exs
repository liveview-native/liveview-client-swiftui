defmodule LiveViewNative.SwiftUI.RulesParserTest do
  use ExUnit.Case
  alias LiveViewNative.SwiftUI.RulesParser

  def parse(input, opts \\ []) do
    RulesParser.parse(input,
      file: Keyword.get(opts, :file),
      module: Keyword.get(opts, :module),
      line: Keyword.get(opts, :line),
      context: %{
        annotations: Keyword.get(opts, :annotations, false)
      }
    )
  end

  describe "parse/1" do
    test "parses modifier function definition with annotation" do
      {line, input} = {__ENV__.line, "\nbold(true)"}

      # We add 1 because the modifier is on the second line of the input
      output = {:bold, [file: __ENV__.file, line: line + 1, module: __ENV__.module], [true]}

      assert parse(input,
               file: __ENV__.file,
               module: __ENV__.module,
               line: line,
               annotations: true
             ) ==
               output
    end

    test "parses modifier function definition" do
      input = "bold(true)"
      output = {:bold, [], [true]}

      assert parse(input) == output
    end

    test "parses modifier with multiple arguments" do
      input = "background(\"foo\", \"bar\")"
      output = {:background, [], ["foo", "bar"]}

      assert parse(input) == output

      # space at start and end
      input = "background( \"foo\", \"bar\" )"
      assert parse(input) == output

      # space at start only
      input = "background( \"foo\", \"bar\")"
      assert parse(input) == output

      # space at end only
      input = "background(\"foo\", \"bar\" )"
      assert parse(input) == output
    end

    test "parses atoms as an argument value" do
      input = "background(content: :star_red)"
      output = {:background, [], [[content: :star_red]]}

      assert parse(input) == output
    end

    test "parses string wrapped atoms as an argument value" do
      input = "background(content: :\"star-red\")"
      output = {:background, [], [[content: :"star-red"]]}

      assert parse(input) == output
    end

    test "parses a naked IME" do
      input = "font(.largeTitle)"

      output = {:font, [], [{:., [], [nil, :largeTitle]}]}

      assert parse(input) == output
    end

    test "parses comma seperated IMEs" do
      input = "font(.largeTitle, .bold)"

      output = {:font, [], [{:., [], [nil, :largeTitle]}, {:., [], [nil, :bold]}]}

      assert parse(input) == output
    end

    test "parses chained IMEs" do
      input = "font(color: Color.red)"

      output = {:font, [], [[color: {:., [], [:Color, :red]}]]}

      assert parse(input) == output

      input = "font(color: Color.red.shadow(.thick))"

      output =
        {:font, [],
         [[color: {:., [], [:Color, {:., [], [:red, {:shadow, [], [{:., [], [nil, :thick]}]}]}]}]]}

      assert parse(input) == output
    end

    test "parses naked chained IME" do
      input = "font(.largeTitle.red)"

      output = {:font, [], [{:., [], [nil, {:., [], [:largeTitle, :red]}]}]}

      assert parse(input) == output
    end


    test "parses multiple modifiers" do
      input = "font(.largeTitle) bold(true) italic(true)"

      output = [
        {:font, [], [{:., [], [nil, :largeTitle]}]},
        {:bold, [], [true]},
        {:italic, [], [true]}
      ]

      assert parse(input) == output
    end

    test "parses complex modifier chains" do
      input = "color(color: .foo.bar.baz(1, 2).qux)"

      output =
        {:color, [],
         [
           [
             color:
               {:., [],
                [nil, {:., [], [:foo, {:., [], [:bar, {:., [], [{:baz, [], [1, 2]}, :qux]}]}]}]}
           ]
         ]}

      assert parse(input) == output
    end

    test "parses multiline" do
      input = """
      font(.largeTitle)
      bold(true)
      italic(true)
      """

      output = [
        {:font, [], [{:., [], [nil, :largeTitle]}]},
        {:bold, [], [true]},
        {:italic, [], [true]}
      ]

      assert parse(input) == output
    end

    test "parses string literal value type" do
      input = "foo(\"bar\")"
      output = {:foo, [], ["bar"]}

      assert parse(input) == output
    end

    test "parses numerical types" do
      input = "foo(1, -1, 1.1)"
      output = {:foo, [], [1, -1, 1.1]}

      assert parse(input) == output
    end

    test "parses underscore numbers" do
      input = "foo(1_000, 1_000_000_000_000, 1_000.4)"
      output = {:foo, [], [1_000, 1_000_000_000_000, 1_000.4]}

      assert parse(input) == output
    end

    test "parses key/value pairs" do
      input = ~s|foo(bar: "baz", qux: .quux)|
      output = {:foo, [], [[bar: "baz", qux: {:., [], [nil, :quux]}]]}

      assert parse(input) == output
    end

    test "parses key/value pairs with helper calls" do
      input = "foo(x: to_integer(value), y: 0)"
      output = {:foo, [], [[{:x, {Elixir, [], {:to_integer, [], [{:value, [], Elixir}]}}}, {:y, 0}]]}

      assert parse(input) == output
    end

    test "parses bool and nil values" do
      input = "foo(true, false, nil)"
      output = {:foo, [], [true, false, nil]}

      assert parse(input) == output
    end

    test "parses Implicit Member Expressions" do
      input = "color(.red)"
      output = {:color, [], [{:., [], [nil, :red]}]}

      assert parse(input) == output
    end

    test "parses nested function calls" do
      input = ~s|foo(bar("baz"))|
      output = {:foo, [], [{:bar, [], ["baz"]}]}

      assert parse(input) == output
    end

    test "parses attr value references" do
      input = ~s|foo(attr("bar"))|
      output = {:foo, [], [{:__attr__, [], "bar"}]}

      assert parse(input) == output
    end

    test "parses variables" do
      input = "foo(color_name)"
      output = {:foo, [], [{Elixir, [], {:color_name, [], Elixir}}]}

      assert parse(input) == output
    end

    test "parses closed ranges" do
      input = "foo(Foo.bar...Baz.qux)"
      output = {:foo, [], [{:..., [], [{:., [], [:Foo, :bar]}, {:., [], [:Baz, :qux]}]}]}

      assert parse(input) == output

      input = "foo(1...10)"
      output = {:foo, [], [{:..., [], [1, 10]}]}

      assert parse(input) == output

      input = "foo(\"a\"...\"z\")"
      output = {:foo, [], [{:..., [], ["a", "z"]}]}

      assert parse(input) == output
    end

    test "parses left-hand range" do
      input = "foo(Foo.bar...)"
      output = {:foo, [], [{:..., [], [{:., [], [:Foo, :bar]}, nil]}]}

      assert parse(input) == output

      input = "foo(1...)"
      output = {:foo, [], [{:..., [], [1, nil]}]}

      assert parse(input) == output

      input = "foo(\"a\"...)"
      output = {:foo, [], [{:..., [], ["a", nil]}]}

      assert parse(input) == output
    end

    test "parses right-hand range" do
      input = "foo(...Baz.qux)"
      output = {:foo, [], [{:..., [], [nil, {:., [], [:Baz, :qux]}]}]}

      assert parse(input) == output

      input = "foo(...10)"
      output = {:foo, [], [{:..., [], [nil, 10]}]}

      assert parse(input) == output

      input = "foo(...\"z\")"
      output = {:foo, [], [{:..., [], [nil, "z"]}]}

      assert parse(input) == output
    end

    test "parses half-open range" do
      input = "foo(Foo.bar..<Baz.qux)"
      output = {:foo, [], [{:"..<", [], [{:., [], [:Foo, :bar]}, {:., [], [:Baz, :qux]}]}]}

      assert parse(input) == output

      input = "foo(1..<10)"
      output = {:foo, [], [{:"..<", [], [1, 10]}]}

      assert parse(input) == output

      input = "foo(\"a\"..<\"z\")"
      output = {:foo, [], [{:"..<", [], ["a", "z"]}]}

      assert parse(input) == output
    end

    test "parses half-open right-hand range" do
      input = "foo(..<Baz.qux)"
      output = {:foo, [], [{:"..<", [], [nil, {:., [], [:Baz, :qux]}]}]}

      assert parse(input) == output

      input = "foo(..<10)"
      output = {:foo, [], [{:"..<", [], [nil, 10]}]}

      assert parse(input) == output

      input = "foo(..<\"z\")"
      output = {:foo, [], [{:"..<", [], [nil, "z"]}]}

      assert parse(input) == output
    end
  end

  describe "helper functions" do
    test "to_atom" do
      input = "buttonStyle(style: to_atom(style))"

      output = {:buttonStyle, [], [[style: {Elixir, [], {:to_atom, [], [{:style, [], Elixir}]}}]]}

      assert parse(input) == output
    end

    test "to_integer" do
      input = "frame(height: to_integer(height))"

      output = {:frame, [], [[height: {Elixir, [], {:to_integer, [], [{:height, [], Elixir}]}}]]}

      assert parse(input) == output
    end

    test "to_float" do
      input = "kerning(kerning: to_float(kerning))"

      output =
        {:kerning, [], [[kerning: {Elixir, [], {:to_float, [], [{:kerning, [], Elixir}]}}]]}

      assert parse(input) == output
    end

    test "to_boolean" do
      input = "hidden(to_boolean(is_hidden))"

      output = {:hidden, [], [{Elixir, [], {:to_boolean, [], [{:is_hidden, [], Elixir}]}}]}

      assert parse(input) == output
    end

    test "camelize" do
      input = "font(family: camelize(family))"

      output = {:font, [], [[family: {Elixir, [], {:camelize, [], [{:family, [], Elixir}]}}]]}

      assert parse(input) == output
    end

    test "underscore" do
      input = "font(family: underscore(family))"

      output = {:font, [], [[family: {Elixir, [], {:underscore, [], [{:family, [], Elixir}]}}]]}

      assert parse(input) == output
    end

    test "to_ime" do
      input = "color(to_ime(color))"

      output =
        {:color, [], [{:., [], [nil, {Elixir, [], {:to_atom, [], [{:color, [], Elixir}]}}]}]}

      assert parse(input) == output
    end

    test "to_ime with chaining" do
      input = "color(to_ime(color).foo)"

      output =
        {:color, [],
         [{:., [], [nil, {:., [], [{Elixir, [], {:to_atom, [], [{:color, [], Elixir}]}}, :foo]}]}]}

      assert parse(input) == output
    end

    test "to_ime in the middle of a chain" do
      input = "color(Foo.to_ime(color).bar)"

      output = {:color, [], [{:., [], [:Foo, {:., [], [{Elixir, [], {:to_atom, [], [{:color, [], Elixir}]}}, :bar]}]}]}

      assert parse(input) == output
    end

    @tag :skip
    test "to_ime as a function call" do
      # for now I'm not sure how to implement the AST for this.
      # input "color(foo.to_ime(color)(1).bar)"

      # output = {:color, [], [{:., [], [:foo, {:., [], [{Elixir, [], {:to_ime, [], [{:color, [], Elixir}]}}, :bar]}]}]}

      # assert parse(input) == output
    end

    test "event" do
      input = ~s{searchable(change: event("search-event", throttle: 10_000))}
      output = {:searchable, [], [[change: {:__event__, [], ["search-event", [throttle: 10_000]]}]]}

      assert parse(input) == output
    end
  end

  describe "Sheet test" do
    test "ensure the swiftui sheet compiles as expected" do
      output = MockSheet.compile_ast(["color-red"], target: :all)

      assert output == %{"color-red" => [
        {:color, [], [{:., [], [nil, :red]}]}
      ]}
    end

    test "ensure to_ime doesn't double print ast node" do
      output = MockSheet.compile_ast(["button-plain"], target: :all)

      assert output == %{"button-plain" => [
        {:buttonStyle, [], [{:., [], [nil, :plain]}]}
      ]}
    end
  end

  describe "error reporting" do
    setup do
      # Disable ANSI so we don't have to worry about colors
      Application.put_env(:elixir, :ansi_enabled, false)
      on_exit(fn -> Application.put_env(:elixir, :ansi_enabled, true) end)
    end

    test "ANSI is off" do
      assert "message" == IO.iodata_to_binary(IO.ANSI.format([:blue, "message"]))
    end

    test "modifier without brackets" do
      input = "blue"

      error =
        assert_raise SyntaxError, fn ->
          parse(input)
        end

      error_prefix =
        """
        Unsupported input:
          |
        1 | blue‎
          |     ^
          |

        Expected ‘()’ or ‘(<modifier_arguments>)’ where <modifier_arguments> are a comma separated list of:
         - a number, string, nil, boolean or :atom
         - an event eg ‘event(\"search-event\", throttle: 10_000)’
         - an attribute eg ‘attr(\"placeholder\")’
         - an IME eg ‘Color.red’ or ‘.largeTitle’ or ‘Color.to_ime(variable)’
         - a list of keyword pairs eg ‘style: :dashed’, ‘size: 12’ or  ‘style: [lineWidth: 1]’
         - a helper function eg ‘to_float(variable)’
         - a modifier eg ‘bold()’
         - a variable defined in the class header eg ‘color_name’
        """
        |> String.trim()

      assert String.trim(error.description) == error_prefix
    end

    test "invalid modifier name" do
      input = "1(.red)"

      error =
        assert_raise SyntaxError, fn ->
          parse(input)
        end

      error_prefix =
        """
        Unsupported input:
          |
        1 | 1(.red)
          | ^
          |

        Expected a modifier name, but got ‘1’
        """
        |> String.trim()

      assert String.trim(error.description) == error_prefix
    end

    test "invalid modifier argument" do
      input = "font(Color.largeTitle.)"

      error =
        assert_raise SyntaxError, fn ->
          parse(input)
        end

      error_prefix =
        """
        Unsupported input:
          |
        1 | font(Color.largeTitle.)
          |                      ^
          |

        expected ‘)’
        """
        |> String.trim()

      assert String.trim(error.description) == error_prefix
    end

    test "invalid modifier argument2" do
      input = "abc(11, 2a)"

      error =
        assert_raise SyntaxError, fn ->
          parse(input)
        end

      error_prefix =
        """
        Unsupported input:
          |
        1 | abc(11, 2a)
          |          ^
          |

        Invalid suffix on number
        """
        |> String.trim()

      assert String.trim(error.description) == error_prefix
    end

    test "invalid keyword pair: missing colon" do
      input = "abc(def: 11, b: [lineWidth a, l: 2a])"

      error =
        assert_raise SyntaxError, fn ->
          parse(input)
        end

      error_prefix =
        """
        Unsupported input:
          |
        1 | abc(def: 11, b: [lineWidth‎ a, l: 2a])
          |                           ^
          |

        expected ‘:’
        """
        |> String.trim()

      assert String.trim(error.description) == error_prefix
    end

    test "invalid keyword pair: double nesting" do
      input = "abc(def: 11, b: lineWidth: a, l: 2a]"

      error =
        assert_raise SyntaxError, fn ->
          parse(input)
        end

      error_prefix =
        """
        Unsupported input:
          |
        1 | abc(def: 11, b: lineWidth: a, l: 2a]
          |                          ^
          |

        expected ‘)’
        """
        |> String.trim()

      assert String.trim(error.description) == error_prefix
    end

    test "invalid keyword pair: invalid value" do
      input = "abc(def: 11, b: [lineWidth: 1lineWidth])"

      error =
        assert_raise SyntaxError, fn ->
          parse(input)
        end

      error_prefix =
        """
        Unsupported input:
          |
        1 | abc(def: 11, b: [lineWidth: 1lineWidth])
          |                              ^^^^^^^^^
          |

        Invalid suffix on number
        """
        |> String.trim()

      assert String.trim(error.description) == error_prefix
    end

    test "invalid keyword pair: invalid value (2)" do
      input = "abc(def: 11, b: [lineWidth: :1])"

      error =
        assert_raise SyntaxError, fn ->
          parse(input)
        end

      error_prefix =
        """
        Unsupported input:
          |
        1 | abc(def: 11, b: [lineWidth: :1])
          |                              ^
          |

        Expected an atom, but got ‘1’
        """
        |> String.trim()

      assert String.trim(error.description) == error_prefix
    end

    test "invalid keyword pair: invalid value (3)" do
      input = "abc(def: 11, b: :1)"

      error =
        assert_raise SyntaxError, fn ->
          parse(input)
        end

      error_prefix =
        """
        Unsupported input:
          |
        1 | abc(def: 11, b: :1)
          |                  ^
          |

        Expected an atom, but got ‘1’
        """
        |> String.trim()

      assert String.trim(error.description) == error_prefix
    end

    test "unexpected trailing character" do
      input = "font(.largeTitle) {"

      error =
        assert_raise SyntaxError, fn ->
          parse(input)
        end

      error_prefix =
        """
        Unsupported input:
          |
        1 | font(.largeTitle) {
          |                   ^
          |

        Expected a modifier name, but got ‘{’
        """
        |> String.trim()

      assert String.trim(error.description) == error_prefix
    end

    test "unexpected bracket" do
      input = "font(.)red)"

      error =
        assert_raise SyntaxError, fn ->
          parse(input)
        end

      error_prefix =
        """
        Unsupported input:
          |
        1 | font(.)red)
          |      ^
          |

        Expected one of the following:
         - a number, string, nil, boolean or :atom
         - an event eg ‘event("search-event", throttle: 10_000)’
         - an attribute eg ‘attr("placeholder")’
         - an IME eg ‘Color.red’ or ‘.largeTitle’ or ‘Color.to_ime(variable)’
         - a list of keyword pairs eg ‘style: :dashed’, ‘size: 12’ or  ‘style: [lineWidth: 1]’
         - a helper function eg ‘to_float(variable)’
         - a modifier eg ‘bold()’
         - a variable defined in the class header eg ‘color_name’
        """
        |> String.trim()

      assert String.trim(error.description) == error_prefix
    end

    test "event as modifier" do
      input = "event(variable)"

      error =
        assert_raise SyntaxError, fn ->
          parse(input)
        end

      error_prefix =
        """
        Unsupported input:
          |
        1 | event(variable)
          | ^^^^^
          |

        ‘event’ can only be used as an argument to a modifier eg ‘searchable(change: event(\"search-event\", throttle: 10_000))’
        """
        |> String.trim()

      assert String.trim(error.description) == error_prefix
    end

    test "event with non-string as first argument" do
      input = "foo(event(variable))"

      error =
        assert_raise SyntaxError, fn ->
          parse(input)
        end

      error_prefix =
        """
        Unsupported input:
          |
        1 | foo(event(variable))
          |           ^^^^^^^^
          |

        ‘event’ expects a string as the first argument
        """
        |> String.trim()

      assert String.trim(error.description) == error_prefix
    end

    test "event with non-keyword as second arg" do
      input = "foo(event(\"click\", 1))"

      error =
        assert_raise SyntaxError, fn ->
          parse(input)
        end

      error_prefix =
        """
        Unsupported input:
          |
        1 | foo(event("click", 1))
          |                    ^
          |

        ‘event’ expects a keyword list as the second argument
        """
        |> String.trim()

      assert String.trim(error.description) == error_prefix
    end

    test "attr with non-string" do
      input = "foo(attr(1))"

      error =
        assert_raise SyntaxError, fn ->
          parse(input)
        end

      error_prefix =
        """
        Unsupported input:
          |
        1 | foo(attr(1))
          |          ^
          |

        ‘attr’ expects a string argument
        """
        |> String.trim()

      assert String.trim(error.description) == error_prefix
    end
  end
end
