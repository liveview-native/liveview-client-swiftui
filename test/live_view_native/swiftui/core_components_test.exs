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
    test "hidden" do
      assigns = %{}

      template = ~LVN"""
      <.input type="hidden" value="123" name="test-name" />
      """

      assert t2h(template) ==
        ~X"""
       <LiveHiddenField name="test-name" value="123" />
      """
    end

    test "TextFieldLink" do
      assigns = %{}

      template = ~LVN"""
      <.input type="TextFieldLink" value="123" name="test-name" prompt="test-prompt" label="test-label" />
      """

      assert t2h(template) ==
        ~X"""
        <VStack alignment="leading">
          <LabeledContent>
            <Text template="label">test-label</Text>
            <TextFieldLink name="test-name" value="123" prompt="test-prompt">
              test-label
            </TextFieldLink>
          </LabeledContent>
        </VStack>
        """
    end

    test "DatePicker" do
      assigns = %{}

      template = ~LVN"""
      <.input type="DatePicker" value="123" name="test-name" label="test-label" />
      """

      assert t2h(template) ==
        ~X"""
        <VStack alignment="leading">
          <DatePicker name="test-name" selection="123">
            test-label
          </DatePicker>
        </VStack>
        """
    end

    test "MultiDatePicker" do
      assigns = %{}

      template = ~LVN"""
      <.input type="MultiDatePicker" value="123" name="test-name" label="test-label" />
      """

      assert t2h(template) ==
        ~X"""
        <VStack alignment="leading">
          <LabeledContent>
            <Text template="label">test-label</Text>
            <MultiDatePicker name="test-name" selection="123">test-label</MultiDatePicker>
          </LabeledContent>
        </VStack>
        """
    end

    test "Picker" do
      assigns = %{}

      template = ~LVN"""
      <.input type="Picker" value="123" name="test-name" label="test-label" options={[{"a", "b"}]} />
      """

      assert t2h(template) ==
        ~X"""
        <VStack alignment="leading">
          <Picker name="test-name" selection="123">
            <Text template="label">test-label</Text>
            <Text tag="b">
              a
            </Text>
          </Picker>
        </VStack>
        """
    end

    test "Slider" do
      assigns = %{}

      template = ~LVN"""
      <.input type="Slider" value="123" name="test-name" label="test-label" min={1} max={200} />
      """

      assert t2h(template) ==
        ~X"""
        <VStack alignment="leading">
          <LabeledContent>
            <Text template="label">test-label</Text>
            <Slider name="test-name" value="123" lowerBound="1" upperBound="200">test-label</Slider>
          </LabeledContent>
        </VStack>
        """
    end

    test "Stepper" do
      assigns = %{}

      template = ~LVN"""
      <.input type="Stepper" value="123" name="test-name" label="test-label" />
      """

      assert t2h(template) ==
        ~X"""
        <VStack alignment="leading">
          <LabeledContent>
            <Text template="label">test-label</Text>
            <Stepper name="test-name" value="123"></Stepper>
          </LabeledContent>
        </VStack>
        """
    end

    test "TextEditor" do
      assigns = %{}

      template = ~LVN"""
      <.input type="TextEditor" value="123" name="test-name" label="test-label" />
      """

      assert t2h(template) ==
        ~X"""
        <VStack alignment="leading">
          <LabeledContent>
            <Text template="label">test-label</Text>
            <TextEditor name="test-name" text="123" />
          </LabeledContent>
        </VStack>
        """
    end

    test "TextField" do
      assigns = %{}

      template = ~LVN"""
      <.input type="TextField" value="123" name="test-name" prompt="test-prompt" label="test-label" />
      """

      assert t2h(template) ==
        ~X"""
        <VStack alignment="leading">
          <TextField name="test-name" text="123" prompt="test-prompt">test-label</TextField>
        </VStack>
        """
    end

    test "TextField with placeholder" do
      assigns = %{}

      template = ~LVN"""
      <.input type="TextField" value="123" name="test-name" prompt="test-prompt" placeholder="test-placeholder" label="test-label" />
      """

      assert t2h(template) ==
        ~X"""
        <VStack alignment="leading">
          <TextField name="test-name" text="123" prompt="test-prompt">test-placeholder</TextField>
        </VStack>
        """
    end

    test "SecureField" do
      assigns = %{}

      template = ~LVN"""
      <.input type="SecureField" value="123" name="test-name" prompt="test-prompt" label="test-label" />
      """

      assert t2h(template) ==
        ~X"""
        <VStack alignment="leading">
          <SecureField name="test-name" text="123" prompt="test-prompt">test-label</SecureField>
        </VStack>
        """
    end

    test "SecureField with placeholder" do
      assigns = %{}

      template = ~LVN"""
      <.input type="SecureField" value="123" name="test-name" prompt="test-prompt" placeholder="test-placeholder" label="test-label" />
      """

      assert t2h(template) ==
        ~X"""
        <VStack alignment="leading">
          <SecureField name="test-name" text="123" prompt="test-prompt">test-placeholder</SecureField>
        </VStack>
        """
    end

    test "Toggle" do
      assigns = %{}

      template = ~LVN"""
      <.input type="Toggle" checked={true} name="test-name" label="test-label" />
      """

      assert t2h(template) ==
        ~X"""
        <VStack alignment="leading">
          <LabeledContent>
            <Text template="label">test-label</Text>
            <Toggle name="test-name" isOn="true"></Toggle>
          </LabeledContent>
        </VStack>
        """
    end
  end

  describe "error/1" do
    test "renders the error message" do
      assigns = %{}

      template = ~LVN"""
      <.error>
        <Text>Error!</Text>
      </.error>
      """

      assert t2h(template) ==
        ~X"""
        <Group style="font(.caption); foregroundStyle(.red)">
          <Text>Error!</Text>
        </Group>
        """

    end

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
          <Text>{item.title}</Text>
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
