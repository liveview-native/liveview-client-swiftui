defmodule LiveViewNativeSwiftUi.Modifiers.ImageScale do
  use LiveViewNativePlatform.Modifier

  modifier_schema "image_scale" do
    field :scale, Ecto.Enum, values: ~w(small medium large)a
  end
end
