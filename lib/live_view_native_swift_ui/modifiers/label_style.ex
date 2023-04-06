defmodule LiveViewNativeSwiftUi.Modifiers.LabelStyle do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.KeyName

  modifier_schema "label_style" do
    field :style, KeyName
  end
end
