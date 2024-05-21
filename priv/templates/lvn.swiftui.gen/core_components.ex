defmodule <%= inspect context.web_module %>.CoreComponents.<%= inspect context.module_suffix %> do
  @moduledoc """
  Provides core UI components built for SwiftUI.<%= unless @live_form? do %>
  > #### No LiveForm Installed! {: .warning}
  >
  > You will not get access to any of the form related inputs without LiveForm. After it is installed regenerate
  > this file with `mix lvn.swiftui.gen --no-xcodegen`<% end %>

  This file contains feature parity components to your applications's CoreComponent module.
  The goal is to retain a common API for fast prototyping. Leveraging your existing knowledge
  of the `<%= inspect context.web_module %>.CoreComponents` functions you should expect identical functionality for similarly named
  components between web and native. That means utilizing your existing `handle_event/3` functions to manage state
  and stay focused on adding new templates for your native applications.

  The default components use `LiveViewNative.SwiftUI.UtilityStyles`, a generated styling syntax
  that allows you to call nearly any modifier. Refer to the documentation in `LiveViewNative.SwiftUI` for more information.

  Icons are referenced by a system name. Read more about the [Xcode Asset Manager](https://developer.apple.com/documentation/xcode/asset-management)
  to learn how to include different assets in your LiveView Native applications. In addition, you can also use [SF Symbols](https://developer.apple.com/sf-symbols/).
  On any MacOS open Spotlight and search `SF Symbols`. The catalog application will provide a reference name that can be used. All SF Symbols
  are incuded with all SwiftUI applications.

  Most of this documentation was "borrowed" from the analog Phoenix generated file to ensure this project is expressing the same behavior.
  """

  use LiveViewNative.Component<%= if @live_form? do %>

  import LiveViewNative.LiveForm.Component

  @doc """
  Renders an input with label and error messages.

  A `Phoenix.HTML.FormField` may be passed as argument,
  which is used to retrieve the input name, id, and values.
  Otherwise all attributes may be passed explicitly.

  ## Types

  This function accepts all SwiftUI input types, considering that:

    * You may also set `type="Picker"` to render a `<Picker>` tag

    * `type="Toggle"` is used exclusively to render boolean values

  ## Examples

      <Group class="keyboardType(.emailAddress)">
        <.input field={@form[:email]} type="TextField" />
        <.input name="my-input" errors={["oh no!"]} />
      </Group>

  [INSERT LVATTRDOCS]
  """
  @doc type: :component

  attr :id, :any, default: nil
  attr :name, :any
  attr :label, :string, default: nil
  attr :value, :any

  attr :type, :string,
    default: "TextField",
    values: ~w(TextFieldLink DatePicker MultiDatePicker Picker SecureField Slider Stepper TextEditor TextField Toggle hidden)

  attr :field, Phoenix.HTML.FormField,
    doc: "a form field struct retrieved from the form, for example: `@form[:email]`"

  attr :errors, :list, default: []
  attr :checked, :boolean, doc: "the checked flag for checkbox inputs"
  attr :prompt, :string, default: nil, doc: "the prompt for select inputs"
  attr :options, :list, doc: "the options to pass to `Phoenix.HTML.Form.options_for_select/2`"
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

  @doc """
  Generates a generic error message.
  """
  @doc type: :component
  slot :inner_block, required: true

  def error(assigns) do
    ~LVN"""
    <Group class="font-caption fg-red">
      <%%= render_slot(@inner_block) %>
    </Group>
    """
  end<% end %>

  @doc """
  Renders a header with title.

  [INSERT LVATTRDOCS]
  """
  @doc type: :component

  attr :class, :string, default: nil

  slot :inner_block, required: true
  slot :subtitle
  slot :actions

  def header(assigns) do
    ~LVN"""
    <VStack class={[
      "navigation-title-:title navigation-subtitle-:subtitle toolbar--toolbar",
      @class
      ]}>
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

  @doc """
  Renders a modal.

  ## Examples

      <.modal show={@show} id="confirm-modal">
        This is a modal.
      </.modal>

  An event name may be passed to the `:on_cancel` to configure
  the closing/cancel event, for example:

      <.modal show={@show} id="confirm" on_cancel="toggle-show">
        This is another modal.
      </.modal>

  """
  attr :id, :string, required: true
  attr :show, :boolean, default: false
  attr :on_cancel, :string
  slot :inner_block, required: true

  def modal(assigns) do
    ~LVN"""
    <VStack
      id={@id}
      :if={@show}
      class="sheet-isPresented:[attr(presented)]-content::content"
      presented={@show}
      phx-change={@on_cancel}
    >
      <VStack template="content">
        <%%= render_slot(@inner_block) %>
      </VStack>
    </VStack>
    """
  end

  @doc """
  Renders flash notices.

  ## Examples

      <.flash kind={:info} flash={@flash} />
      <.flash kind={:info} phx-mounted={show("#flash")}>Welcome Back!</.flash>
  """
  attr :id, :string, doc: "the optional id of flash container"
  attr :flash, :map, default: %{}, doc: "the map of flash messages to display"
  attr :title, :string, default: nil
  attr :kind, :atom, values: [:info, :error], doc: "used for styling and flash lookup"
  attr :rest, :global, doc: "the arbitrary attributes to add to the flash container"

  slot :inner_block, doc: "the optional inner block that renders the flash message"

  def flash(assigns) do
    assigns = assign_new(assigns, :id, fn -> "flash-#{assigns.kind}" end)

    ~LVN"""
    <%% msg = render_slot(@inner_block) || Phoenix.Flash.get(@flash, @kind) %>
    <VStack
      :if={msg != nil}
      class="hidden alert-[attr(title)]-isPresented:[attr(presented)]-actions::actions-message::message"
      title={@title}
      presented={msg != nil}
      id={@id}
      {@rest}
      phx-change="lv:clear-flash"
      phx-value-key={@kind}
    >
      <Text template="message"><%%= msg %></Text>
      <Button template="actions">Ok</Button>
    </VStack>
    """
  end

  @doc """
  Shows the flash group with standard titles and content.

  ## Examples

      <.flash_group flash={@flash} />
  """
  attr :flash, :map, required: true, doc: "the map of flash messages"
  attr :id, :string, default: "flash-group", doc: "the optional id of flash container"

  def flash_group(assigns) do
    ~LVN"""
    <Group id={@id}>
      <.flash kind={:info} title={"Success!"} flash={@flash} />
      <.flash kind={:error} title={"Error!"} flash={@flash} />
    </Group>
    """
  end<%= if @live_form? do %>

  @doc """
  Renders a simple form.

  ## Examples

      <.simple_form for={@form} phx-change="validate" phx-submit="save">
        <.input field={@form[:email]} label="Email"/>
        <.input field={@form[:username]} label="Username" />
        <:actions>
          <.button>Save</.button>
        </:actions>
      </.simple_form>

  [INSERT LVATTRDOCS]
  """
  @doc type: :component

  attr :for, :any, required: true, doc: "the datastructure for the form"
  attr :as, :any, default: nil, doc: "the server side parameter to collect all input under"

  attr :rest, :global,
    include: ~w(autocomplete name rel action enctype method novalidate target multipart),
    doc: "the arbitrary attributes to apply to the form tag"

  slot :inner_block, required: true
  slot :actions, doc: "the slot for form actions, such as a submit button"

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
  end

  @doc """
  Renders a button.

  ## Examples

      <.button>Send!</.button>
      <.button phx-click="go">Send!</.button>
  """
  @doc type: :component

  attr :type, :string, default: nil
  attr :class, :string, default: nil
  attr :rest, :global, include: ~w(disabled form name value)

  slot :inner_block, required: true

  def button(%{ type: "submit" } = assigns) do
    ~LVN"""
    <Section>
      <LiveSubmitButton class={[
        "button-style-borderedProminent control-size-large",
        "list-row-insets-EdgeInsets() list-row-background-:empty",
        @class]}>
        <Group class="max-w-infinity bold @class">
          <%%= render_slot(@inner_block) %>
        </Group>
      </LiveSubmitButton>
    </Section>
    """
  end

  def button(assigns) do
    ~LVN"""
    <Button class={@class} {@rest}>
      <%%= render_slot(@inner_block) %>
    </Button>
    """
  end<% end %>

  @doc ~S"""
  Renders a table with generic styling.

  ## Examples

      <.table id="users" rows={@users}>
        <:col :let={user} label="id"><%%= user.id %></:col>
        <:col :let={user} label="username"><%%= user.username %></:col>
      </.table>
  """
  @doc type: :component

  attr :id, :string, required: true
  attr :rows, :list, required: true
  attr :row_id, :any, default: nil, doc: "the function for generating the row id"

  attr :row_item, :any,
    default: &Function.identity/1,
    doc: "the function for mapping each row before calling the :col and :action slots"

  slot :col, required: true do
    attr :label, :string
  end

  slot :action, doc: "the slot for showing user actions in the last table column"

  def table(assigns) do
    ~LVN"""
    <Table id={@id}>
      <Group template="columns">
        <TableColumn :for={col <- @col}><%%= col[:label] %></TableColumn>
        <TableColumn :if={@action != []} />
      </Group>
      <Group template="rows">
        <TableRow
          :for={{row, i} <- Enum.with_index(@rows)}
          id={(@row_id && @row_id.(row)) || i}
        >
          <VStack :for={col <- @col}>
            <%%= render_slot(col, @row_item.(row)) %>
          </VStack>
          <HStack :if={@action != []}>
            <%%= for action <- @action do %>
              <%%= render_slot(action, @row_item.(row)) %>
            <%% end %>
          </HStack>
        </TableRow>
      </Group>
    </Table>
    """
  end

  @doc """
  Renders a data list.

  ## Examples

      <.list>
        <:item title="Title"><%%= @post.title %></:item>
        <:item title="Views"><%%= @post.views %></:item>
      </.list>
  """
  slot :item, required: true do
    attr :title, :string, required: true
  end

  def list(assigns) do
    ~LVN"""
    <List>
      <LabeledContent :for={item <- @item}>
        <Text template="label"><%%= item.title %></Text>
        <%%= render_slot(item) %>
      </LabeledContent>
    </List>
    """
  end

  @doc """
  Renders a system image from the Asset Manager in Xcode
  or from SF Symbols.

  ## Examples

      <.icon name="xmark.diamond" />
  """
  @doc type: :component

  attr :name, :string, required: true
  attr :class, :string, default: nil
  def icon(assigns) do
    ~LVN"""
    <Image systemName={@name} class={@class} />
    """
  end

  @doc """
  Renders an image from a url

  Will render an [`AsyncImage`](https://developer.apple.com/documentation/swiftui/asyncimage)
  You can customize the lifecycle states of with the slots.
  """

  attr :url, :string, required: true
  attr :rest, :global
  slot :empty, doc: """
    The empty state that will render before has successfully been downloaded.

        <.image url={~p"/assets/images/logo.png"}>
          <:empty>
            <Image systemName="myloading.spinner" />
          </:empty>
        </.image>

    [See SwiftUI docs](https://developer.apple.com/documentation/swiftui/asyncimagephase/success(_:))
    """
  slot :success, doc: """
    The success state that will render when the image has successfully been downloaded.

        <.image url={~p"/assets/images/logo.png"}>
          <:success class="main-logo"/>
        </.image>

    [See SwiftUI docs](https://developer.apple.com/documentation/swiftui/asyncimagephase/success(_:))
    """
  do
    attr :class, :string
  end
  slot :failure, doc: """
    The failure state that will render when the image fails to downloaded.

        <.image url={~p"/assets/images/logo.png"}>
          <:failure class="image-fail"/>
        </.image>

    [See SwiftUI docs](https://developer.apple.com/documentation/swiftui/asyncimagephase/failure(_:))

  """
  do
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
  end<%= if @live_form? do %>

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
      Gettext.dngettext(<%= inspect context.web_module %>.Gettext, "errors", msg, msg, count, opts)
    else
      Gettext.dgettext(<%= inspect context.web_module %>.Gettext, "errors", msg, opts)
    end
  end<% else %>
  def translate_error({msg, opts}) do
    # You can make use of gettext to translate error messages by
    # uncommenting and adjusting the following code:

    # if count = opts[:count] do
    #   Gettext.dngettext(<%= inspect context.web_module %>.Gettext, "errors", msg, msg, count, opts)
    # else
    #   Gettext.dgettext(<%= inspect context.web_module %>.Gettext, "errors", msg, opts)
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
