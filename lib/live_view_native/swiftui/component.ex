defmodule LiveViewNative.SwiftUI.Component do
  @moduledoc """
  Define reusable function components with NEEx templates.

  Function components in `LiveView Native` are identical in every
  way to function components in `Live View`.
  """
  use LiveViewNative.Component

  defmacro __using__(_) do
    quote do
      import LiveViewNative.Component, only: [sigil_LVN: 2]
      import unquote(__MODULE__)
    end
  end

  @doc """
  Generates a link to a given route.

  Unlike LiveView's own `link` component, only `href` and `navigate` are supported.
  `patch` cannot be expressed with `NavigationLink`. Use `push_patch` within `handle_event` to patch the URL.

  `href` will generate a [`<Link>`](https://developer.apple.com/documentation/swiftui/link) view which will delegate
  to the user's default web browser.

  `navigate` will generate a [`<NavigationLink>`](https://developer.apple.com/documentation/swiftui/navigationlink) view
  which will be handled by the client as a navigation request back to the LiveView server.

  [INSERT LVATTRDOCS]

  ## Examples

  ```heex
  <.link href="/">Regular anchor link</.link>
  ```

  ```heex
  <.link navigate={~p"/"} class="underline">home</.link>
  ```

  ```heex
  <.link navigate={~p"/?sort=asc"} replace={false}>
    Sort By Price
  </.link>
  ```

  ```heex
  <.link href={URI.parse("https://elixir-lang.org")}>hello</.link>
  ```
  """

  # TODO: discuss supporting the following from the LV docs:
  # ```heex
  # <.link href="/the_world" method="delete" data-confirm="Really?">delete</.link>
  # ```

  # ## JavaScript dependency

  # In order to support links where `:method` is not `"get"` or use the above data attributes,
  # `Phoenix.HTML` relies on JavaScript. You can load `priv/static/phoenix_html.js` into your
  # build tool.

  # ### Data attributes

  # Data attributes are added as a keyword list passed to the `data` key. The following data
  # attributes are supported:

  # * `data-confirm` - shows a confirmation prompt before generating and submitting the form when
  # `:method` is not `"get"`.

  # ### Overriding the default confirm behaviour

  # You can customize the confirm dialog in your app's client code.
  # Any event on an element with a `data-confirm` attribute will first call the provided
  # `eventConfirmation` function. Provide a custom function with a `(String, ElementNode) async -> Bool`
  # signature to show a custom dialog.

  # ```swift
  # struct ContentView: View {
  #   @State private var showEventConfirmation: Bool = false
  #   @State private var eventConfirmationTransaction: EventConfirmationTransaction?
  #   struct EventConfirmationTransaction: Sendable, Identifiable {
  #       let id = UUID()
  #       let message: String
  #       let role: ButtonRole?
  #       let callback: @Sendable (sending Bool) -> ()
  #   }
  #
  #   var body: some View {
  #       #LiveView(
  #           .localhost,
  #           configuration: LiveSessionConfiguration(eventConfirmation: { message, element in
  #               return await withCheckedContinuation { @MainActor continuation in
  #                   showEventConfirmation = true
  #                   eventConfirmationTransaction = EventConfirmationTransaction(
  #                       message: message,
  #                       role: try? element.attributeValue(ButtonRole.self, for: "data-confirm-role"), // access a custom attribute
  #                       callback: continuation.resume(returning:)
  #                   )
  #               }
  #           }),
  #           addons: [.liveForm]
  #       ) {
  #           ConnectingView()
  #       } disconnected: {
  #           DisconnectedView()
  #       } reconnecting: { content, isReconnecting in
  #           ReconnectingView(isReconnecting: isReconnecting) {
  #               content
  #           }
  #       } error: { error in
  #           ErrorView(error: error)
  #       }
  #       .alert(
  #           eventConfirmationTransaction?.message ?? "",
  #           isPresented: $showEventConfirmation,
  #           presenting: eventConfirmationTransaction
  #       ) { transaction in
  #           Button("Confirm", role: transaction.role) {
  #               transaction.callback(true)
  #           }
  #           Button("Cancel", role: .cancel) {
  #               transaction.callback(false)
  #           }
  #       }
  #   }
  # }
  # ```

  # ## CSRF Protection

  # By default, CSRF tokens are generated through `Plug.CSRFProtection`.
  # """

  @doc type: :component
  attr(:navigate, :string,
    doc: """
    Navigates from a LiveView to a new LiveView.
    The browser page is kept, but a new LiveView process is mounted and its content on the page
    is reloaded. It is only possible to navigate between LiveViews declared under the same router
    `Phoenix.LiveView.Router.live_session/3`. Otherwise, a full browser redirect is used.
    """
  )

  attr(:patch, :string,
    doc: """
    Patches the current LiveView.
    The `handle_params` callback of the current LiveView will be invoked and the minimum content
    will be sent over the wire, as any other LiveView diff.
    """
  )

  attr(:href, :any,
    doc: """
    Uses traditional browser navigation to the new location.
    This means the whole page is reloaded on the browser.
    """
  )

  attr(:replace, :boolean,
    default: false,
    doc: """
    When using `:patch` or `:navigate`,
    should the browser's history be replaced with `pushState`?
    """
  )

  # attr(:method, :string,
  #   default: "get",
  #   doc: """
  #   The HTTP method to use with the link. This is intended for usage outside of LiveView
  #   and therefore only works with the `href={...}` attribute. It has no effect on `patch`
  #   and `navigate` instructions.

  #   In case the method is not `get`, the link is generated inside the form which sets the proper
  #   information. In order to submit the form, JavaScript must be enabled in the browser.
  #   """
  # )

  # attr(:csrf_token, :any,
  #   default: true,
  #   doc: """
  #   A boolean or custom token to use for links with an HTTP method other than `get`.
  #   """
  # )

  attr(:rest, :global,
    # include: ~w(download hreflang referrerpolicy rel target type),
    include: ~w(type),
    doc: """
    Additional attributes added to the `<NavigationLink>` tag.
    """
  )

  slot(:inner_block,
    required: true,
    doc: """
    The content rendered inside of the `<NavigationLink>` tag.
    """
  )

  def link(%{navigate: to} = assigns, _interface) when is_binary(to) do
    ~LVN"""
    <NavigationLink
      destination={@navigate}
      data-phx-link="redirect"
      data-phx-link-state={if @replace, do: "replace", else: "push"}
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </NavigationLink>
    """
  end

  def link(%{patch: to} = assigns, _interface) when is_binary(to) do
    ~LVN"""
    <NavigationLink
      destination={@patch}
      data-phx-link="patch"
      data-phx-link-state={if @replace, do: "replace", else: "push"}
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </NavigationLink>
    """
  end

  def link(%{href: href} = assigns, _interface) when href != "#" and not is_nil(href) do
    href = Phoenix.LiveView.Utils.valid_destination!(href, "<.link>")
    assigns = assign(assigns, :href, href)

    ~LVN"""
    <Link destination={@href} {@rest}>
      <%= render_slot(@inner_block) %>
    </Link>
    """
  end

  def link(%{} = assigns, _interface) do
    ~LVN"""
    <NavigationLink destination="#" {@rest}>
      <%= render_slot(@inner_block) %>
    </NavigationLink>
    """
  end

  @doc """
  Builds a file input tag for a LiveView upload.

  [INSERT LVATTRDOCS]

  ## Drag and Drop

  Drag and drop is supported by annotating the droppable container with a `phx-drop-target`
  attribute pointing to the UploadConfig `ref`, so the following markup is all that is required
  for drag and drop support:

  ```heex
  <div class="container" phx-drop-target={@uploads.avatar.ref}>
    <!-- ... -->
    <.live_file_input upload={@uploads.avatar} />
  </div>
  ```

  ## Examples

  Rendering a file input:

  ```heex
  <.live_file_input upload={@uploads.avatar} />
  ```

  Rendering a file input with a label:

  ```heex
  <label for={@uploads.avatar.ref}>Avatar</label>
  <.live_file_input upload={@uploads.avatar} />
  ```
  """
  @doc type: :component

  attr :upload, Phoenix.LiveView.UploadConfig,
    required: true,
    doc: "The `Phoenix.LiveView.UploadConfig` struct"

  attr :accept, :string,
    doc:
      "the optional override for the accept attribute. Defaults to :accept specified by allow_upload"

  attr :rest, :global, include: ~w(webkitdirectory required disabled capture form)

  def live_file_input(%{upload: upload} = assigns, _interface) do
    assigns = assign_new(assigns, :accept, fn -> upload.accept != :any && upload.accept end)

    ~LVN"""
    <VStack
      style='fileImporter(id: attr("id"), name: attr("name"), isPresented: attr("is-presented"), allowedContentTypes: attr("accept"), allowsMultipleSelection: attr("multiple"))'
      is-presented
      id={@upload.ref}
      name={@upload.name}
      accept={@accept}
      data-phx-update="ignore"
      data-phx-upload-ref={@upload.ref}
      data-phx-active-refs={join_refs(for(entry <- @upload.entries, do: entry.ref))}
      data-phx-done-refs={join_refs(for(entry <- @upload.entries, entry.done?, do: entry.ref))}
      data-phx-preflighted-refs={join_refs(for(entry <- @upload.entries, entry.preflighted?, do: entry.ref))}
      data-phx-auto-upload={@upload.auto_upload?}
      {if @upload.max_entries > 1, do: Map.put(@rest, :multiple, true), else: @rest}
    />
    """
  end

  defp join_refs(entries), do: Enum.join(entries, ",")

  @doc ~S"""
  Generates an image preview on the client for a selected file.

  [INSERT LVATTRDOCS]

  ## Examples

  ```heex
  <%= for entry <- @uploads.avatar.entries do %>
    <.live_img_preview entry={entry} width="75" />
  <% end %>
  ```

  When you need to use it multiple times, make sure that they have distinct ids

  ```heex
  <%= for entry <- @uploads.avatar.entries do %>
    <.live_img_preview entry={entry} width="75" />
  <% end %>

  <%= for entry <- @uploads.avatar.entries do %>
    <.live_img_preview id={"modal-#{entry.ref}"} entry={entry} width="500" />
  <% end %>
  ```
  """
  @doc type: :component

  attr :entry, Phoenix.LiveView.UploadEntry,
    required: true,
    doc: "The `Phoenix.LiveView.UploadEntry` struct"

  attr :id, :string,
    default: nil,
    doc:
      "the id of the img tag. Derived by default from the entry ref, but can be overridden as needed if you need to render a preview of the same entry multiple times on the same page"

  attr :rest, :global, []

  def live_img_preview(assigns, _interface) do
    ~LVN"""
    <Image
      id={@id || "phx-preview-#{@entry.ref}"}
      data-phx-upload-ref={@entry.upload_ref}
      data-phx-entry-ref={@entry.ref}
      data-phx-update="ignore"
      {@rest}
    />
    """
  end
end
