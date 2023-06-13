defmodule LiveViewNativeSwiftUi.Types.ContentTransition do
  @derive Jason.Encoder
  defstruct [:type, :properties]

  use LiveViewNativePlatform.Modifier.Type
  def type, do: :map

  def cast(type) when is_atom(type), do: {:ok, %__MODULE__{ type: type, properties: nil }}
  def cast({:symbol_effect = type, effect}), do: cast({type, effect, []})
  def cast({:symbol_effect = type, effect, options}) do
    {:ok, %__MODULE__{
      type: type,
      properties: %{ effect: effect, options: Enum.map(options, &LiveViewNativeSwiftUi.Types.Transition.cast_symbol_effect_option/1) }
    }}
  end
  def cast({type, [ {k, _} | _ ] = properties}) when is_atom(type) and is_atom(k) do
    {:ok, %__MODULE__{ type: type, properties: Enum.into(properties, %{}) }}
  end

  def cast(_), do: :error
end
