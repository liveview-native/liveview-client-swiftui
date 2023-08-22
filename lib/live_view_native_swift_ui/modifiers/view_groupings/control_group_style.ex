defmodule LiveViewNativeSwiftUi.Modifiers.ControlGroupStyle do
  use LiveViewNativePlatform.Modifier

  modifier_schema "control_group_style" do
    field :style, Ecto.Enum, values: ~w(automatic compact_menu menu navigation)a
  end

  def params(style) when is_atom(style) and not is_boolean(style) and not is_nil(style), do: [style: style]
  def params(params), do: params
end
