defmodule LiveViewNativeSwiftUi.Types.Animation do
  @derive Jason.Encoder
  defstruct [:type, :properties, :modifiers]

  use LiveViewNativePlatform.Modifier.Type
  def type, do: :map

  def cast(value) when is_atom(value), do: {:ok, %__MODULE__{ type: value, properties: %{}, modifiers: [] }}
  def cast({value, [ {k, _} | _ ] = properties}) when is_atom(value) and is_atom(k) do
    {:ok, %__MODULE__{ type: value, properties: Enum.into(properties, %{}), modifiers: [] }}
  end
  def cast({value, [ {k, _} | _ ] = properties, modifiers}) when is_atom(value) and is_atom(k) and is_list(modifiers) do
    {:ok, %__MODULE__{ type: value, properties: Enum.into(properties, %{}), modifiers: Enum.map(modifiers, &cast_modifier/1) }}
  end

  def cast(_), do: :error

  def cast_modifier({type, properties}) when is_list(properties), do: %{ type: type, properties: Enum.into(properties, %{}) }
  def cast_modifier({type, properties}), do: %{ type: type, properties: properties }
end
