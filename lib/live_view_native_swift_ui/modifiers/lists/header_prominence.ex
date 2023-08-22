defmodule LiveViewNativeSwiftUi.Modifiers.HeaderProminence do
  use LiveViewNativePlatform.Modifier

  modifier_schema "header_prominence" do
    field :prominence, Ecto.Enum, values: ~w(increased standard)a
  end

  def params(prominence) when is_atom(prominence) and not is_boolean(prominence) and not is_nil(prominence), do: [prominence: prominence]
  def params(params), do: params
end
