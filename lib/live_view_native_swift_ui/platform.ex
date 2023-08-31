defmodule LiveViewNativeSwiftUi.Platform do
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

    def compile(struct) do
      LiveViewNativePlatform.Env.define(:swiftui,
        custom_modifiers: struct.custom_modifiers,
        render_macro: :sigil_SWIFTUI,
        otp_app: :live_view_native_swift_ui
      )
    end
  end
end
