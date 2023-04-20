defmodule LiveViewNativeSwiftUi.Modifiers.CoordinateSpace do
  use LiveViewNativePlatform.Modifier

  modifier_schema "coordinate_space" do
    field :name, :string
  end
end
