defmodule LiveViewNativeSwiftUi.Modifiers.MenuIndicatorVisibility do
  use LiveViewNativePlatform.Modifier

  modifier_schema "menu_indicator" do
    field(:visibility, Ecto.Enum, values: ~w(automatic hidden visible)a)
  end

  def params(visibility) when is_atom(visibility) and not is_boolean(visibility) and not is_nil(visibility), do: [visibility: visibility]
  def params(params), do: params
end
