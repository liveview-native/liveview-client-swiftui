defmodule LiveViewNativeSwiftUi.Types.Angle do
  use LiveViewNativePlatform.Modifier.Type
  def type, do: :float

  def cast({:degrees, deg}), do: {:ok, deg * (:math.pi / 180)}
  def cast({:radians, rad}), do: {:ok, rad}
  def cast(_), do: :error
end
