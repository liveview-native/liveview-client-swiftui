defmodule LiveViewNativeSwiftUi.Types.Gesture do
  @derive Jason.Encoder
  defstruct [:type, :properties]

  use LiveViewNativePlatform.Modifier.Type
  def type, do: :map

  def cast({type, sequence}) when is_list(sequence) and type in [:sequential, :simultaneous, :exclusive] do
    {:ok, %__MODULE__{ type: type, properties: %{ :gestures => Enum.map(sequence, fn g -> elem(cast(g), 1) end) } }}
  end
  def cast(type) when is_atom(type), do: {:ok, %__MODULE__{ type: type, properties: %{} }}
  def cast({type, [{k, _} | _] = properties}) when is_atom(type) and is_list(properties) and is_atom(k) do
    {:ok, %__MODULE__{ type: type, properties: Enum.into(properties, %{}) }}
  end

  def cast(_), do: :error
end
