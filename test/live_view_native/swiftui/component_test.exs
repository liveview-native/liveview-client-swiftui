defmodule LiveViewNative.SwiftUI.ComponentTest do
  use ExUnit.Case

  import LiveViewNative.SwiftUI.Component
  import LiveViewNative.Component, only: [sigil_LVN: 2]
  import LiveViewNative.Template.Parser, only: [parse_document!: 1]

  defmacro sigil_X({:<<>>, _, [binary]}, []) when is_binary(binary) do
    Macro.escape(parse_sorted!(binary))
  end

  defmacro sigil_x(term, []) do
    quote do
      unquote(__MODULE__).parse_sorted!(unquote(term))
    end
  end

  def t2h(template) do
    template
    |> Phoenix.LiveViewTest.rendered_to_string()
    |> parse_sorted!()
  end

  def trim(str) when is_binary(str), do: String.trim(str)
  def trim(list) when is_list(list), do: Enum.map(list, &trim/1)
  def trim(tuple) when is_tuple(tuple), do: tuple |> Tuple.to_list() |> trim() |> List.to_tuple()

  @doc """
  Parses LVN templates into Floki format with sorted attributes.
  """
  def parse_sorted!(value) do
    value
    |> parse_document!()
    |> Enum.map(&normalize_attribute_order/1)
    |> trim()
  end

  defp normalize_attribute_order({node_type, attributes, content}),
    do: {node_type, Enum.sort(attributes), Enum.map(content, &normalize_attribute_order/1)}

  defp normalize_attribute_order(values) when is_list(values),
    do: Enum.map(values, &normalize_attribute_order/1)

  defp normalize_attribute_order(value), do: value

  describe "link" do
    test "navigate" do
      assigns = %{}
      template = ~LVN"""
      <.link navigate="/">Home</.link>
      """

      assert t2h(template) ==
        ~X"""
        <NavigationLink
          destination="/"
          data-phx-link="redirect"
          data-phx-link-state="push"
        >
          Home
        </NavigationLink>
      """
    end

    test "navigate with replace" do
      assigns = %{}
      template = ~LVN"""
      <.link navigate="/" replace={true}>Home</.link>
      """

      assert t2h(template) ==
        ~X"""
        <NavigationLink
          destination="/"
          data-phx-link="redirect"
          data-phx-link-state="replace"
        >
          Home
        </NavigationLink>
      """
    end

    test "patch" do
      assigns = %{}
      template = ~LVN"""
      <.link patch="/">Home</.link>
      """

      assert t2h(template) ==
        ~X"""
        <NavigationLink
          destination="/"
          data-phx-link="patch"
          data-phx-link-state="push"
        >
          Home
        </NavigationLink>
      """
    end

    test "patch with replace" do
      assigns = %{}
      template = ~LVN"""
      <.link patch="/" replace={true}>Home</.link>
      """

      assert t2h(template) ==
        ~X"""
        <NavigationLink
          destination="/"
          data-phx-link="patch"
          data-phx-link-state="replace"
        >
          Home
        </NavigationLink>
      """
    end
  end
end

