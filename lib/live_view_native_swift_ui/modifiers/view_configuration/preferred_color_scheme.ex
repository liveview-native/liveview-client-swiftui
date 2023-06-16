defmodule LiveViewNativeSwiftUi.Modifiers.PreferredColorScheme do
  use LiveViewNativePlatform.Modifier

  modifier_schema "preferred_color_scheme" do
    field :color_scheme, Ecto.Enum, values: ~w(light dark)a
  end

  def params(color_scheme) when is_atom(color_scheme) and not is_boolean(color_scheme) and not is_nil(color_scheme), do: [color_scheme: color_scheme]
  def params(params), do: params
end
