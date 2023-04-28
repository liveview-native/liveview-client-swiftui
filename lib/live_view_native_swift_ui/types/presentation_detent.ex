defmodule LiveViewNativeSwiftUi.Types.PresentationDetent do
  @derive Jason.Encoder
  defstruct [:type, :value]

  use LiveViewNativePlatform.Modifier.Type
  def type, do: :map

  def cast(value) when value in [:large, :medium], do: {:ok, %__MODULE__{type: value, value: nil}}

  def cast({type, value}) when type in [:fraction, :height] and is_number(value),
    do: {:ok, %__MODULE__{type: type, value: value}}

  def cast(_), do: :error
end
