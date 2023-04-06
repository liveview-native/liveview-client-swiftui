defmodule LiveViewNativeSwiftUi.Types.FontWidth do
  @derive Jason.Encoder
  defstruct [:name, :value]

  use LiveViewNativePlatform.Modifier.Type
  def type, do: :map

  def cast(name) when is_atom(name), do: {:ok, %__MODULE__{ name: name }}
  def cast(value) when is_number(value), do: {:ok, %__MODULE__{ value: value }}
  def cast(_), do: :error
end
