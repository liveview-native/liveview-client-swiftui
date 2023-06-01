defmodule LiveViewNativeSwiftUi.Modifiers.RenderingMode do
  use LiveViewNativePlatform.Modifier

  modifier_schema "rendering_mode" do
    field :mode, Ecto.Enum, values: ~w(original template)a
  end
end
