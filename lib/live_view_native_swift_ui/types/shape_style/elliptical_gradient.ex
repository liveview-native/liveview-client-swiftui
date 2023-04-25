defmodule LiveViewNativeSwiftUi.Types.EllipticalGradient do
  @derive Jason.Encoder
  defstruct [
    :gradient,
    center: {0.5, 0.5},
    start_radius_fraction: 0,
    end_radius_fraction: 0.5
  ]

  use LiveViewNativePlatform.Modifier.Type
  def type, do: :map

  alias LiveViewNativeSwiftUi.Types.Gradient
  alias LiveViewNativeSwiftUi.Types.UnitPoint

  def cast(value) when is_map(value) or is_list(value) do
    with {:ok, gradient} <- Gradient.cast(value[:gradient]),
         {:ok, center} <- UnitPoint.cast(value[:center] || {0.5, 0.5})
    do
      {:ok, %__MODULE__{
        gradient: gradient,
        center: center,
        start_radius_fraction: value[:start_radius_fraction] || 0,
        end_radius_fraction: value[:end_radius_fraction] || 0.5
      }}
    else
      _ ->
        :error
    end
  end

  def cast(_), do: :error
end
