defmodule LiveViewNativeSwiftUi.Types.ListItemTint do
  @derive Jason.Encoder
  defstruct [:type, :color]

  use LiveViewNativePlatform.Modifier.Type
  def type, do: :map

  alias LiveViewNativeSwiftUi.Types.Color

  def cast(type) when is_atom(type), do: {:ok, %__MODULE__{ type: type, color: nil }}
  def cast({type, color}) do
    {:ok, color} = Color.cast(color)
    {:ok, %__MODULE__{ type: type, color: color }}
  end

  def cast(_), do: :error
end
