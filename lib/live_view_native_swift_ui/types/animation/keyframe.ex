defmodule LiveViewNativeSwiftUi.Types.Keyframe do
  @derive Jason.Encoder
  defstruct [:type, :value, :properties]

  use LiveViewNativePlatform.Modifier.Type
  def type, do: :map

  def cast({:spring = type, value, properties}) when is_number(value) do
    {:ok, %__MODULE__{ type: type, value: value, properties: Enum.into(properties, %{}) |> Map.replace_lazy(:spring, &cast_spring/1) }}
  end
  def cast({type, value, properties}) when is_atom(type) and is_number(value) do
    {:ok, %__MODULE__{ type: type, value: value, properties: Enum.into(properties, %{}) }}
  end

  def cast(_), do: :error

  defp cast_spring(type) when is_atom(type), do: %{ type: type }
  defp cast_spring({type, properties}), do: Enum.into(properties, %{}) |> Map.put_new(:type, type)
  defp cast_spring(properties), do: Enum.into(properties, %{})
end
