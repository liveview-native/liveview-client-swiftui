defmodule LiveViewNativeSwiftUi.Types.Event do
  @derive Jason.Encoder
  defstruct [:event, :type, :params, :target, :debounce, :throttle]

  use LiveViewNativePlatform.Modifier.Type
  def type, do: :map

  def cast(event) when is_bitstring(event), do: {:ok, %__MODULE__{ event: event }}
  def cast(value) when is_map(value) do
    value = value
      |> Map.update(:params, Jason.encode!(Map.new()), fn params -> Jason.encode!(params) end)
    dbg value
    {:ok, struct(__MODULE__, value)}
  end
  def cast(_), do: :error
end
