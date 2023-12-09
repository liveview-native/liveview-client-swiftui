defmodule LiveViewNative.SwiftUI.Platform do
  defstruct [
    :app_name,
    :os_name,
    :os_version,
    :simulator_opts,
    :user_interface_idiom,
    custom_modifiers: []
  ]

  defimpl LiveViewNativePlatform.Kit do
    require Logger

    @default_layouts %{
      app: "<%= @inner_content %>",
      root: """
        <csrf-token value={get_csrf_token()} />
        <NavigationStack>
          <%= @inner_content %>
        </NavigationStack>
      """
    }

    def compile(struct) do
      LiveViewNativePlatform.Env.define(:swiftui,
        custom_modifiers: struct.custom_modifiers,
        default_layouts: @default_layouts,
        render_macro: :sigil_SWIFTUI,
        otp_app: :live_view_native_swiftui,
        valid_targets: ~w(mac pad phone tv vision watch)a
      )
    end
  end
end
