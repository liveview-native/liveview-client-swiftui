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
      output = {:bold, [file: __ENV__.file, line: line + 1, module: __ENV__.module, source: "bold(true)"], [true]}

      assert parse(input,
               file: __ENV__.file,
               module: __ENV__.module,
               line: line,
               annotations: true
             ) ==
               output
      end

      test "parses modifier function definition with annotation (2)" do
      {line, input} = {__ENV__.line,"""
      font(.largeTitle)
      bold(true)
      italic(true)
      """}

      output = [
        {:font, [file: __ENV__.file, line: line, module: __ENV__.module, source: "font(.largeTitle)"], [{:., [file: __ENV__.file, line: line, module: __ENV__.module, source: "font(.largeTitle)"], [nil, :largeTitle]}]},
        {:bold, [file: __ENV__.file, line: line + 1, module: __ENV__.module, source: "bold(true)"], [true]},
        {:italic, [file: __ENV__.file, line: line + 2, module: __ENV__.module, source: "italic(true)"], [true]}
      ]

      assert parse(input,
          file: __ENV__.file,
          module: __ENV__.module,
          line: line,
          annotations: true
        ) == output
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

      input = "foregroundStyle(Color(.displayP3, red: 0.4627, green: 0.8392, blue: 1.0).opacity(0.25))"

      output =
        {:foregroundStyle, [], [{:., [], [{:Color, [], [{:., [], [nil, :displayP3]}, [red: 0.4627, green: 0.8392, blue: 1.0]]}, {:opacity, [], [0.25]}]}]}

      assert parse(input) == output
    end

    test "parses naked chained IME" do
      input = "font(.largeTitle.red)"

      output = {:font, [], [{:., [], [nil, {:., [], [:largeTitle, :red]}]}]}

      assert parse(input) == output
    end

    test "parses non-key-value lists" do
      input = ~s/Gradient([0, 1, 2])/
      output = {:Gradient, [], [[0, 1, 2]]}
      assert parse(input) == output

      input = ~s/Gradient([0, 1, 2], 3)/
      output = {:Gradient, [], [[0, 1, 2], 3]}
      assert parse(input) == output

      input = ~s/Gradient(colors: [0, 1, 2])/
      output = {:Gradient, [], [[colors: [0, 1, 2]]]}
      assert parse(input) == output

      input = ~s/Gradient(colors: [Color.red, Color.blue])/
      output = {:Gradient, [], [[colors: [{:., [], [:Color, :red]}, {:., [], [:Color, :blue]}]]]}
      assert parse(input) == output

      input = ~s/Gradient(colors: ["red", "blue"])/
      output = {:Gradient, [], [[colors: ["red", "blue"]]]}
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

    test "parses single character variables" do
      input = "foo(c)"
      output = {:foo, [], [{Elixir, [], {:c, [], Elixir}}]}

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

    test "can compile custom classes using the RULES sigil" do
      output = MockSheet.compile_ast(["color-blue"], target: :all)

      assert output == %{"color-blue" => [
        {:color, [], [{:., [], [nil, :blue]}]}
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
         - a list of values eg ‘[1, 2, 3]’, ‘["red", "blue"]’ or ‘[Color.red, Color.blue]’
         - a Swift range eg ‘1..<10’ or ‘foo(Foo.bar...Baz.qux)’
         - a number, string, nil, boolean or :atom
         - an event eg ‘event(\"search-event\", throttle: 10_000)’
         - an attribute eg ‘attr(\"placeholder\")’
         - an IME eg ‘Color.red’ or ‘.largeTitle’’
         - a list of keyword pairs eg ‘style: :dashed’, ‘size: 12’ or  ‘style: [lineWidth: 1]’
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

    test "invalid keyword list: missing closing brace" do
      input = "abc(def: 11, b: [lineWidth: 1)"

      error =
        assert_raise SyntaxError, fn ->
          parse(input)
        end

      error_prefix =
        """
        Unsupported input:
          |
        1 | abc(def: 11, b: [lineWidth: 1)
          |                              ^
          |

        expected ‘]’
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
         - a list of values eg ‘[1, 2, 3]’, ‘["red", "blue"]’ or ‘[Color.red, Color.blue]’
         - a Swift range eg ‘1..<10’ or ‘foo(Foo.bar...Baz.qux)’
         - a number, string, nil, boolean or :atom
         - an event eg ‘event("search-event", throttle: 10_000)’
         - an attribute eg ‘attr("placeholder")’
         - an IME eg ‘Color.red’ or ‘.largeTitle’’
         - a list of keyword pairs eg ‘style: :dashed’, ‘size: 12’ or  ‘style: [lineWidth: 1]’
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
