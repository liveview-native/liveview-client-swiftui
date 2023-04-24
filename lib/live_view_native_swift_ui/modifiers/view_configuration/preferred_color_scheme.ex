defmodule LiveViewNativeSwiftUi.Modifiers.PreferredColorScheme do
  use LiveViewNativePlatform.Modifier

  modifier_schema "preferred_color_scheme" do
    field :color_scheme, Ecto.Enum, values: ~w(light dark)a
  end
end
