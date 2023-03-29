defmodule LiveViewNativeSwiftUi.Modifiers.Opacity do
  use LiveViewNativePlatform.Modifier

  modifier_schema "opacity" do
    field :opacity, :float
  end
end
