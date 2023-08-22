defmodule LiveViewNativeSwiftUi.Modifiers.MenuOrder do
  use LiveViewNativePlatform.Modifier

  modifier_schema "menu_order" do
    field(:order, Ecto.Enum, values: ~w(automatic fixed priority)a)
  end

  def params(order) when is_atom(order) and not is_boolean(order) and not is_nil(order), do: [order: order]
  def params(params), do: params
end
