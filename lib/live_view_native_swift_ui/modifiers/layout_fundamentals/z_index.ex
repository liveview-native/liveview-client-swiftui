defmodule LiveViewNativeSwiftUi.Modifiers.ZIndex do
  use LiveViewNativePlatform.Modifier

  modifier_schema "z_index" do
    field :value, :float
  end
end
