defmodule LiveViewNativeSwiftUi.Types.ShapeStyle do
  @derive Jason.Encoder
  defstruct [:concrete_style, :style, :modifiers]

  use LiveViewNativePlatform.Modifier.Type
  def type, do: :map

  alias LiveViewNativeSwiftUi.Types.Color
  alias LiveViewNativeSwiftUi.Types.AngularGradient
  alias LiveViewNativeSwiftUi.Types.EllipticalGradient
  alias LiveViewNativeSwiftUi.Types.LinearGradient
  alias LiveViewNativeSwiftUi.Types.RadialGradient
  alias LiveViewNativeSwiftUi.Types.ImagePaint

  @static_styles [:selection, :separator, :tint, :foreground, :background]

  def cast(value) when value in @static_styles do
    {:ok, %__MODULE__{ concrete_style: value, style: nil, modifiers: [] }}
  end
  def cast({value, modifiers}) when value in @static_styles do
    {:ok, %__MODULE__{ concrete_style: value, style: nil, modifiers: Enum.map(modifiers, &cast_modifier/1) }}
  end
  def cast({concrete_style, style}), do: cast({concrete_style, style, []})
  def cast({concrete_style, style, modifiers}) do
    case cast_style({concrete_style, style}) do
      {:ok, cast_style} ->
        {:ok, %__MODULE__{
          concrete_style: concrete_style,
          style: cast_style,
          modifiers: Enum.map(modifiers, &cast_modifier/1)
        }}

      :error ->
        :error
    end
  end

  def cast(_), do: :error

  ###

  defp cast_style({:color, value}), do: Color.cast(value)
  defp cast_style({:angular_gradient, value}), do: AngularGradient.cast(value)
  defp cast_style({:elliptical_gradient, value}), do: EllipticalGradient.cast(value)
  defp cast_style({:linear_gradient, value}), do: LinearGradient.cast(value)
  defp cast_style({:radial_gradient, value}), do: RadialGradient.cast(value)
  defp cast_style({:hierarchical, value}), do: {:ok, value}
  defp cast_style({:material, value}), do: {:ok, value}
  defp cast_style({:image, value}), do: ImagePaint.cast(value)
  defp cast_style(_), do: :error

  defp cast_modifier({type, properties}), do: %{ "type" => type, "properties" => properties }
end
