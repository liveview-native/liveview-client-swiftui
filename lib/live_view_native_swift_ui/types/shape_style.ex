defmodule LiveViewNativeSwiftUi.Types.ShapeStyle do
  @derive Jason.Encoder
  defstruct [:concrete_style, :style]

  alias LiveViewNativeSwiftUi.Types.Color

  use LiveViewNativePlatform.Modifier.Type
  def type, do: :map

  def cast({concrete_style, style}) do
    case cast_style({concrete_style, style}) do
      {:ok, cast_style} ->
        {:ok, %__MODULE__{concrete_style: concrete_style, style: cast_style}}

      :error ->
        :error
    end
  end

  def cast(_), do: :error

  ###

  defp cast_style({:color, value}), do: Color.cast(value)
  defp cast_style(_), do: :error
end
