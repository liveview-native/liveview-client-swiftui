defmodule LiveViewNativeSwiftUi.Types.ContentTransition do
  @derive Jason.Encoder
  defstruct [:type, :properties]

  use LiveViewNativePlatform.Modifier.Type
  def type, do: :map

  def cast(value) when is_atom(value), do: {:ok, %__MODULE__{ type: value, properties: %{} }}
  def cast({value, [ {k, _} | _ ] = properties}) when is_atom(value) and is_atom(k) do
    {:ok, %__MODULE__{ type: value, properties: Enum.into(properties, %{}) }}
  end

  def cast(_), do: :error
end
