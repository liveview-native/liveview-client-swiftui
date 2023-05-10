defmodule LiveViewNativeSwiftUi.Modifiers.FullScreenCover do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.{Event, KeyName, NativeBindingName}

  modifier_schema "full_screen_cover" do
    field(:is_presented, NativeBindingName)
    field(:on_dismiss, Event, default: nil)
    field(:content, KeyName)
  end
end
