defmodule LiveViewNativeSwiftUi.Types.Rotation3DEffectAxis do
  @derive Jason.Encoder
  defstruct [:x, :y, :z]

  use LiveViewNativePlatform.Modifier.Type
  def type, do: :map

  def cast({x, y, z}), do: {:ok, %__MODULE__{ x: x, y: y, z: z }}
  def cast(_), do: :error
end
