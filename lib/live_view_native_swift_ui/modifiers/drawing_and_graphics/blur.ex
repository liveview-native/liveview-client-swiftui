defmodule LiveViewNativeSwiftUi.Modifiers.Blur do
  use LiveViewNativePlatform.Modifier

  modifier_schema "blur" do
    field :radius, :float
    field :opaque, :boolean, default: false
  end
end
