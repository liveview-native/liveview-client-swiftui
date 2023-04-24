defmodule LiveViewNativeSwiftUi.Modifiers.AspectRatio do
  use LiveViewNativePlatform.Modifier

  modifier_schema "aspect_ratio" do
    field :aspect_ratio, {:array, :float}, default: [1.0, 1.0]
    field :content_mode, Ecto.Enum, values: ~w(fill fit)a
  end
end
