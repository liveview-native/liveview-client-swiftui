defmodule <%= inspect context.web_module %>.CoreComponents.<%= inspect context.module_suffix %> do
  use LiveViewNative.Component
<%= if @live_form? do %>
  import LiveViewNative.LiveForm.Component

  attr :id, :any, default: nil
  attr :name, :any
  attr :label, :string, default: nil
  attr :value, :any

  attr :type, :string,
    default: "TextField",
    values: ~w(TextFieldLink DatePicker MultiDatePicker Picker SecureField Slider Stepper TextEditor TextField Toggle hidden)

  attr :field, Phoenix.HTML.FormField,
    doc: "a form field struct retrieved from the form, for example: @form[:email]"

  attr :errors, :list, default: []
  attr :checked, :boolean, doc: "the checked flag for checkbox inputs"
  attr :prompt, :string, default: nil, doc: "the prompt for select inputs"
  attr :options, :list, doc: "the options to pass to Phoenix.HTML.Form.options_for_select/2"
  attr :multiple, :boolean, default: false, doc: "the multiple flag for select inputs"

  attr :min, :any, default: nil
  attr :max, :any, default: nil

  attr :placeholder, :string, default: nil

  attr :readonly, :boolean, default: false

  attr :autocomplete, :string,
    default: "on",
    values: ~w(on off)

  attr :rest, :global,
    include: ~w(disabled step)

  slot :inner_block

  def input(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    assigns
    |> assign(field: nil, id: assigns.id || field.id)
    |> assign(:errors, Enum.map(field.errors, &translate_error(&1)))
    |> assign_new(:name, fn -> if assigns.multiple, do: field.name <> "[]", else: field.name end)
    |> assign_new(:value, fn -> field.value end)
    |> assign(
      :rest,
      Map.put(assigns.rest, :class, [
        Map.get(assigns.rest, :class, ""),
        (if assigns.readonly or Map.get(assigns.rest, :disabled, false), do: "disabled-true", else: ""),
        (if assigns.autocomplete == "off", do: "text-input-autocapitalization-never autocorrection-disabled", else: "")
      ] |> Enum.join(" "))
    )
    |> input()
  end

  def input(%{type: "hidden"} = assigns) do
    ~LVN"""
    <LiveHiddenField id={@id} name={@name} value={@value} {@rest} />
    """
  end

  def input(%{type: "TextFieldLink"} = assigns) do
    ~LVN"""
    <VStack alignment="leading">
      <LabeledContent>
        <Text template="label"><%%= @label %></Text>
        <TextFieldLink id={@id} name={@name} value={@value} prompt={@prompt} {@rest}>
          <%%= @label %>
        </TextFieldLink>
      </LabeledContent>
      <.error :for={msg <- @errors}><%%= msg %></.error>
    </VStack>
    """
  end

  def input(%{type: "DatePicker"} = assigns) do
    ~LVN"""
    <VStack alignment="leading">
      <DatePicker id={@id} name={@name} selection={@value} {@rest}>
        <%%= @label %>
      </DatePicker>
      <.error :for={msg <- @errors}><%%= msg %></.error>
    </VStack>
    """
  end

  def input(%{type: "MultiDatePicker"} = assigns) do
    ~LVN"""
    <VStack alignment="leading">
      <LabeledContent>
        <Text template="label"><%%= @label %></Text>
        <MultiDatePicker id={@id} name={@name} selection={@value} {@rest}><%%= @label %></MultiDatePicker>
      </LabeledContent>
      <.error :for={msg <- @errors}><%%= msg %></.error>
    </VStack>
    """
  end

  def input(%{type: "Picker"} = assigns) do
    ~LVN"""
    <VStack alignment="leading">
      <Picker id={@id} name={@name} selection={@value} {@rest}>
        <Text template="label"><%%= @label %></Text>
        <Text
          :for={{name, value} <- @options}
          tag={value}
        >
          <%%= name %>
        </Text>
      </Picker>
      <.error :for={msg <- @errors}><%%= msg %></.error>
    </VStack>
    """
  end

  def input(%{type: "Slider"} = assigns) do
    ~LVN"""
    <VStack alignment="leading">
      <LabeledContent>
        <Text template="label"><%%= @label %></Text>
        <Slider id={@id} name={@name} value={@value} lowerBound={@min} upperBound={@max} {@rest}><%%= @label %></Slider>
      </LabeledContent>
      <.error :for={msg <- @errors}><%%= msg %></.error>
    </VStack>
    """
  end

  def input(%{type: "Stepper"} = assigns) do
    ~LVN"""
    <VStack alignment="leading">
      <LabeledContent>
        <Text template="label"><%%= @label %></Text>
        <Stepper id={@id} name={@name} value={@value} {@rest}></Stepper>
      </LabeledContent>
      <.error :for={msg <- @errors}><%%= msg %></.error>
    </VStack>
    """
  end

  def input(%{type: "TextEditor"} = assigns) do
    ~LVN"""
    <VStack alignment="leading">
      <LabeledContent>
        <Text template="label"><%%= @label %></Text>
        <TextEditor id={@id} name={@name} text={@value} {@rest} />
      </LabeledContent>
      <.error :for={msg <- @errors}><%%= msg %></.error>
    </VStack>
    """
  end

  def input(%{type: "TextField"} = assigns) do
    ~LVN"""
    <VStack alignment="leading">
      <TextField id={@id} name={@name} text={@value} prompt={@prompt} {@rest}><%%= @placeholder || @label %></TextField>
      <.error :for={msg <- @errors}><%%= msg %></.error>
    </VStack>
    """
  end

  def input(%{type: "SecureField"} = assigns) do
    ~LVN"""
    <VStack alignment="leading">
      <SecureField id={@id} name={@name} text={@value} prompt={@prompt} {@rest}><%%= @placeholder || @label %></SecureField>
      <.error :for={msg <- @errors}><%%= msg %></.error>
    </VStack>
    """
  end

  def input(%{type: "Toggle"} = assigns) do
    ~LVN"""
    <VStack alignment="leading">
      <LabeledContent>
        <Text template="label"><%%= @label %></Text>
        <Toggle id={@id} name={@name} isOn={Map.get(assigns, :checked, Map.get(assigns, :value))} {@rest}></Toggle>
      </LabeledContent>
      <.error :for={msg <- @errors}><%%= msg %></.error>
    </VStack>
    """
  end

  slot :inner_block, required: true

  def error(assigns) do
    ~LVN"""
    <Group class="font-caption fg-red">
      <%%= render_slot(@inner_block) %>
    </Group>
    """
  end<% end %>

  attr :class, :string, default: nil

  slot :inner_block, required: true
  slot :subtitle
  slot :actions

  def header(assigns) do
    ~LVN"""
    <VStack class={"navigation-title-:title navigation-subtitle-:subtitle toolbar--toolbar #{@class}"}>
      <Text template="title">
        <%%= render_slot(@inner_block) %>
      </Text>
      <Text :if={@subtitle != []} template="subtitle">
        <%%= render_slot(@subtitle) %>
      </Text>
      <ToolbarItemGroup template="toolbar">
        <%%= render_slot(@actions) %>
      </ToolbarItemGroup>
    </VStack>
    """
  end

  attr :for, :any, required: true, doc: "the datastructure for the form"
  attr :as, :any, default: nil, doc: "the server side parameter to collect all input under"

  attr :rest, :global,
    include: ~w(autocomplete name rel action enctype method novalidate target multipart),
    doc: "the arbitrary HTML attributes to apply to the form tag"

  slot :inner_block, required: true
  slot :actions, doc: "the slot for form actions, such as a submit button"
<%= if @live_form? do %>
  def simple_form(assigns) do
    ~LVN"""
    <.form :let={f} for={@for} as={@as} {@rest}>
      <Form>
        <%%= render_slot(@inner_block, f) %>
        <Section>
          <%%= for action <- @actions do %>
            <%%= render_slot(action, f) %>
          <%% end %>
        </Section>
      </Form>
    </.form>
    """
  end<% end %>

  attr :type, :string, default: nil
  attr :class, :string, default: nil
  attr :rest, :global, include: ~w(disabled form name value)

  slot :inner_block, required: true
<%= if @live_form? do %>
  def button(%{ type: "submit" } = assigns) do
    ~LVN"""
    <Section>
      <LiveSubmitButton class="button-style-borderedProminent control-size-large list-row-insets-EdgeInsets() list-row-background-:empty">
        <Group class="max-w-infinity bold">
          <%%= render_slot(@inner_block) %>
        </Group>
      </LiveSubmitButton>
    </Section>
    """
  end<% end %>

  def button(assigns) do
    ~LVN"""
    <Button>
      <%%= render_slot(@inner_block) %>
    </Button>
    """
  end

  def table(assigns) do
    ~LVN"""
    <Table></Table>
    """
  end

  attr :name, :string, required: true
  attr :class, :string, default: nil

  def icon(assigns) do
    ~LVN"""
    <Image systemName={@name} class={@class} />
    """
  end

  attr :url, :string, required: true
  attr :rest, :global
  slot :empty
  slot :success do
    attr :class, :string
  end
  slot :failure do
    attr :class, :string
  end

  def image(assigns) do
    ~LVN"""
    <AsyncImage url={@url} {@rest}>
      <Group template="phase.empty" :if={@empty != []}>
        <%%= render_slot(@empty) %>
      </Group>
      <.image_success slot={@success} />
      <.image_failure slot={@failure} />
    </AsyncImage>
    """
  end

  defp image_success(%{ slot: [%{ inner_block: nil }] } = assigns) do
    ~LVN"""
    <AsyncImage image template="phase.success" :for={slot <- @slot} class={slot.class} />
    """
  end

  defp image_success(assigns) do
    ~LVN"""
    <Group template="phase.success" :if={@slot != []}>
      <%%= render_slot(@slot) %>
    </Group>
    """
  end

  defp image_failure(%{ slot: [%{ inner_block: nil }] } = assigns) do
    ~LVN"""
    <AsyncImage error template="phase.failure" :for={slot <- @slot} class={slot.class} />
    """
  end

  defp image_failure(assigns) do
    ~LVN"""
    <Group template="phase.failure" :if={@slot != []}>
      <%%= render_slot(@slot) %>
    </Group>
    """
  end
<%= if @live_form? do %>
  @doc """
  Translates an error message using gettext.
  """<%= if @gettext do %>
  def translate_error({msg, opts}) do
    # When using gettext, we typically pass the strings we want
    # to translate as a static argument:
    #
    #     # Translate the number of files with plural rules
    #     dngettext("errors", "1 file", "%{count} files", count)
    #
    # However the error messages in our forms and APIs are generated
    # dynamically, so we need to translate them by calling Gettext
    # with our gettext backend as first argument. Translations are
    # available in the errors.po file (as we use the "errors" domain).
    if count = opts[:count] do
      Gettext.dngettext(FormDemoWeb.Gettext, "errors", msg, msg, count, opts)
    else
      Gettext.dgettext(FormDemoWeb.Gettext, "errors", msg, opts)
    end
  end<% else %>
  def translate_error({msg, opts}) do
    # You can make use of gettext to translate error messages by
    # uncommenting and adjusting the following code:

    # if count = opts[:count] do
    #   Gettext.dngettext(<%= @web_namespace %>.Gettext, "errors", msg, msg, count, opts)
    # else
    #   Gettext.dgettext(<%= @web_namespace %>.Gettext, "errors", msg, opts)
    # end

    Enum.reduce(opts, msg, fn {key, value}, acc ->
      String.replace(acc, "%{#{key}}", fn _ -> to_string(value) end)
    end)
  end<% end %>

  @doc """
  Translates the errors for a field from a keyword list of errors.
  """
  def translate_errors(errors, field) when is_list(errors) do
    for {^field, {msg, opts}} <- errors, do: translate_error({msg, opts})
  end<% end %>
end
