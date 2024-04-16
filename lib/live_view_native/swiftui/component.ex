defmodule LiveViewNative.SwiftUI.Component do
  @moduledoc false
  use LiveViewNative.Component

  defmacro __using__(_) do
    quote do
      import LiveViewNative.Component, only: [sigil_LVN: 2]
      import LiveViewNative.SwiftUI.Component, only: [sigil_SWIFTUI: 2]
    end
  end

  defmacro sigil_SWIFTUI(doc, modifiers) do
    IO.warn("~SWIFTUI is deprecated and will be removed for v0.4.0 Please change to ~LVN")

    quote do
      sigil_LVN(unquote(doc), unquote(modifiers))
    end
  end

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

  # `NavigationLink` always pushes a new page.
  # attr(:replace, :boolean,
  #   default: false,
  #   doc: """
  #   When using `:patch` or `:navigate`,
  #   should the browser's history be replaced with `pushState`?
  #   """
  # )

  attr(:method, :string,
    default: "get",
    doc: """
    The HTTP method to use with the link. This is intended for usage outside of LiveView
    and therefore only works with the `href={...}` attribute. It has no effect on `patch`
    and `navigate` instructions.

    In case the method is not `get`, the link is generated inside the form which sets the proper
    information. In order to submit the form, JavaScript must be enabled in the browser.
    """
  )

  attr(:csrf_token, :any,
    default: true,
    doc: """
    A boolean or custom token to use for links with an HTTP method other than `get`.
    """
  )

  attr(:rest, :global,
    include: ~w(download hreflang referrerpolicy rel target type),
    doc: """
    Additional HTML attributes added to the `a` tag.
    """
  )

  slot(:inner_block,
    required: true,
    doc: """
    The content rendered inside of the `a` tag.
    """
  )

  def link(%{navigate: to} = assigns) when is_binary(to) do
    ~LVN"""
    <NavigationLink destination={@navigate} {@rest}>
      <%= render_slot(@inner_block) %>
    </NavigationLink>
    """
  end

  # `patch` cannot be expressed with `NavigationLink`.
  # Use `push_patch` within `handle_event` to patch the URL.
  # def link(%{patch: to} = assigns) when is_binary(to) do
  #   ~LVN""
  # end

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
