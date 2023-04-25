defmodule LiveViewNativeSwiftUi.Types.AngularGradient do
  @derive Jason.Encoder
  defstruct [
    :gradient,
    :start_angle,
    :end_angle,
    :angle,
    center: {0.5, 0.5}
  ]

  use LiveViewNativePlatform.Modifier.Type
  def type, do: :map

  alias LiveViewNativeSwiftUi.Types.Gradient
  alias LiveViewNativeSwiftUi.Types.UnitPoint
  alias LiveViewNativeSwiftUi.Types.Angle

  def cast(value) when is_map(value) or is_list(value) do
    with {:ok, gradient} <- Gradient.cast(value[:gradient]),
         {:ok, center} <- UnitPoint.cast(value[:center] || {0.5, 0.5})
    do
      case value[:angle] do
        nil ->
          {:ok, %__MODULE__{
            gradient: gradient,
            center: center,
            angle: nil,
            start_angle: elem(Angle.cast(value[:start_angle]), 1),
            end_angle: elem(Angle.cast(value[:end_angle]), 1)
          }}
        angle ->
          {:ok, %__MODULE__{
            gradient: gradient,
            center: center,
            angle: elem(Angle.cast(angle), 1),
            start_angle: nil,
            end_angle: nil
          }}
      end
    else
      _ ->
        :error
    end
  end

  def cast(_), do: :error
end
