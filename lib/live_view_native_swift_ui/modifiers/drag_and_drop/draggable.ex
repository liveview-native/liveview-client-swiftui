defmodule LiveViewNativeSwiftUi.Modifiers.Draggable do
  alias LiveViewNativeSwiftUi.Types.KeyName
  use LiveViewNativePlatform.Modifier

  modifier_schema "draggable" do
    field :payload, :string
    field :preview, KeyName
  end
end
