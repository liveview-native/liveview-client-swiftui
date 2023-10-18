defmodule LiveViewNative.SwiftUI.RulesParserTest do
  use ExUnit.Case
  import LiveViewNative.SwiftUI.RulesParser, only: [parse: 1]

  describe "parse/1" do
    test "parses modifier function definition" do
      input = "bold(true)"
      output = {:bold, [], [true]}

      assert parse(input) == output
    end

    test "parses modifier function with content syntax" do
      input = "background(){:content}"
      output = {:background, [], [[content: [:content]]]}

      assert parse(input) == output

      # permits whitespace surrounds
      input = "background() { :content }"

      assert parse(input) == output

      # permits array of content references

      input = "background() { [:content1, :content2] }"

      output = {:background, [], [[content: [:content1, :content2]]]}

      assert parse(input) == output

      # permits multiline
      input = """
      background() {
        :content1
        :content2
      }
      """

      assert parse(input) == output

      # supports string wrapped atoms
      input = "background(){:\"star-red\"}"
      output = {:background, [], [[content: [:"star-red"]]]}

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

    test "parses single modifier with atom as IME" do
      input = "font(.largeTitle)"

      output = {:font, [], [{:., [], [nil, :largeTitle]}]}

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

    test "parses chained IMEs within the content block" do
      input = "background() { Color.red }"

      output = {:background, [], [[content: {:., [], [:Color, :red]}]]}

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
        {:color, [], [{:., [], [nil, {Elixir, [], {:to_ime, [], [{:color, [], Elixir}]}}]}]}

      assert parse(input) == output
    end

    test "to_ime with chaining" do
      input = "color(to_ime(color).foo)"

      output =
        {:color, [],
         [{:., [], [nil, {:., [], [{Elixir, [], {:to_ime, [], [{:color, [], Elixir}]}}, :foo]}]}]}

      assert parse(input) == output
    end

    test "to_ime in the middle of a chain" do
      input = "color(Foo.to_ime(color).bar)"

      output = {:color, [], [{:., [], [:Foo, {:., [], [{Elixir, [], {:to_ime, [], [{:color, [], Elixir}]}}, :bar]}]}]}

      assert parse(input) == output
    end

    @tag :skip
    test "to_ime as a function call" do
      # for now I'm not sure how to implement the AST for this.
      # input "color(foo.to_ime(color)(1).bar)"

      # output = {:color, [], [{:., [], [:foo, {:., [], [{Elixir, [], {:to_ime, [], [{:color, [], Elixir}]}}, :bar]}]}]}

      # assert parse(input) == output
    end
  end

  describe "Sheet test" do
    test "ensure the swiftui sheet compiles as expected" do
      output = MockSheet.compile_ast(["color-red"], target: :all)

      assert output == %{"color-red" => [
        {:color, [], [{:., [], [nil, :red]}]}
      ]}
    end
  end
end
