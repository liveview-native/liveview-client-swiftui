defmodule LiveViewNative.SwiftUI.CoreComponentsTest do
  use ExUnit.Case

  import LiveViewNativeTest.CoreComponents.SwiftUI

  import LiveViewNative.LiveForm.Component
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

  @doc """
  Parses LVN templates into Floki format with sorted attributes.
  """
  def parse_sorted!(value) do
    value
    |> parse_document!()
    |> Enum.map(&normalize_attribute_order/1)
  end

  defp normalize_attribute_order({node_type, attributes, content}),
    do: {node_type, Enum.sort(attributes), Enum.map(content, &normalize_attribute_order/1)}

  defp normalize_attribute_order(values) when is_list(values),
    do: Enum.map(values, &normalize_attribute_order/1)

  defp normalize_attribute_order(value), do: value

  describe "input/1" do

  end

  describe "error/1" do

  end

  describe "header/1" do

  end

  describe "modal/1" do

  end

  describe "flash/1" do

  end

  describe "flash_group/1" do

  end

  describe "simple_form/1" do
    test "can render empty form" do
      params = %{}
      form = to_form(params, as: "user")

      assigns = %{form: form}

      template = ~LVN"""
        <.simple_form for={@form}>
        </.simple_form>
        """

      assert t2h(template) ==
        ~X"""
        <LiveForm>
          <Form>
            <Section/>
          </Form>
        </LiveForm>
        """
    end

    test "can render form with an input" do
      params = %{"email" => "test@example.com"}
      form = to_form(params, as: "user")

      assigns = %{form: form}

      template = ~LVN"""
        <.simple_form for={@form}>
          <.input field={@form[:email]} label="Email"/>
        </.simple_form>
        """

      assert t2h(template) ==
        ~X"""
        <LiveForm>
          <Form>
            <VStack alignment="leading">
              <TextField id="user_email" name="user[email]" style="" text="test@example.com">Email</TextField>
            </VStack>
            <Section/>
          </Form>
        </LiveForm>
        """
    end
  end

  describe "button/1" do
    test "will render a button" do
      assigns = %{}

      template = ~LVN"""
      <.button>Send!</.button>
      """

      assert t2h(template) ==
        ~X"""
        <Button>
          Send!
        </Button>
        """

    end
  end

  describe "table" do

  end

  describe "list/1" do
    test "will render a list" do
      assigns = %{}

      template = ~LVN"""
      <.list>
        <:item :for={item <- [%{title: "Foo"}, %{title: "Bar"}]} title={item.title}>
          <Text><%= item.title %></Text>
        </:item>
      </.list>
      """

      assert t2h(template) ==
        ~X"""
        <List>
          <LabeledContent>
            <Text template="label">Foo</Text>
            <Text>Foo</Text>
          </LabeledContent>
          <LabeledContent>
            <Text template="label">Bar</Text>
            <Text>Bar</Text>
          </LabeledContent>
        </List>
        """
    end
  end

  describe "icon/1" do
    test "renders an image tag as a system icon" do
      assigns = %{}

      template = ~LVN"""
        <.icon name="star"/>
        """

      assert t2h(template) ==
        ~X"""
        <Image systemName="star"/>
        """
    end
  end

  describe "image/1" do

  end

  describe "translate_error/1" do

  end

  describe "translate_errors/1" do

  end
end
