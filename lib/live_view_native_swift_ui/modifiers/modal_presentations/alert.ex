defmodule LiveViewNativeSwiftUi.Modifiers.Alert do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.{KeyName, NativeBindingName}

  modifier_schema "alert" do
    field(:title, :string)
    field(:actions, KeyName)
    field(:message, KeyName, default: nil)
    field(:is_presented, NativeBindingName)
  end
end
