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
      import LiveViewNative.SwiftUI.Component, only: [sigil_SWIFTUI: 2]
    end
  end


  @doc false
  defmacro sigil_SWIFTUI(doc, modifiers) do
    IO.warn("~SWIFTUI is deprecated and will be removed for v0.4.0 Please change to ~LVN")

    quote do
      sigil_LVN(unquote(doc), unquote(modifiers))
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

  # `phoenix_html.js` does trigger a custom event `phoenix.link.click` on the clicked DOM element
  # when a click happened. This allows you to intercept the event on its way bubbling up
  # to `window` and do your own custom logic to enhance or replace how the `data-confirm`
  # attribute is handled. You could for example replace the browsers `confirm()` behavior with
  # a custom javascript implementation:

  # ```javascript
  # // listen on document.body, so it's executed before the default of
  # // phoenix_html, which is listening on the window object
  # document.body.addEventListener('phoenix.link.click', function (e) {
  #   // Prevent default implementation
  #   e.stopPropagation();
  #   // Introduce alternative implementation
  #   var message = e.target.getAttribute("data-confirm");
  #   if(!message){ return true; }
  #   vex.dialog.confirm({
  #     message: message,
  #     callback: function (value) {
  #       if (value == false) { e.preventDefault(); }
  #     }
  #   })
  # }, false);
  # ```

  # Or you could attach your own custom behavior.

  # ```javascript
  # window.addEventListener('phoenix.link.click', function (e) {
  #   // Introduce custom behaviour
  #   var message = e.target.getAttribute("data-prompt");
  #   var answer = e.target.getAttribute("data-prompt-answer");
  #   if(message && answer && (answer != window.prompt(message))) {
  #     e.preventDefault();
  #   }
  # }, false);
  # ```

  # The latter could also be bound to any `click` event, but this way you can be sure your custom
  # code is only executed when the code of `phoenix_html.js` is run.

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

  # attr(:patch, :string,
  #   doc: """
  #   Patches the current LiveView.
  #   The `handle_params` callback of the current LiveView will be invoked and the minimum content
  #   will be sent over the wire, as any other LiveView diff.
  #   """
  # )

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

  def link(%{navigate: to} = assigns) when is_binary(to) do
    ~LVN"""
    <NavigationLink
      destination={@navigate}
      data-phx-link-state={if @replace, do: "replace", else: "push"}
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </NavigationLink>
    """
  end

  def link(%{href: href} = assigns) when href != "#" and not is_nil(href) do
    href = Phoenix.LiveView.Utils.valid_destination!(href, "<.link>")
    assigns = assign(assigns, :href, href)

    ~LVN"""
    <Link destination={@href} {@rest}>
      <%= render_slot(@inner_block) %>
    </Link>
    """
  end

  def link(%{} = assigns) do
    ~LVN"""
    <NavigationLink destination="#" {@rest}>
      <%= render_slot(@inner_block) %>
    </NavigationLink>
    """
  end
end
