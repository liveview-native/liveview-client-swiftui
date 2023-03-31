defmodule LiveViewNativeSwiftUi.Modifiers.Tag do
  use LiveViewNativePlatform.Modifier

  modifier_schema "tag" do
    field :tag, :string
  end
end
