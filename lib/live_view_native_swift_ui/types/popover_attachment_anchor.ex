defmodule LiveViewNativeSwiftUi.Types.PopoverAttachmentAnchor do
  @derive Jason.Encoder
  defstruct [
    :type,
    :properties
  ]

  use LiveViewNativePlatform.Modifier.Type
  def type, do: :map

  alias LiveViewNativeSwiftUi.Types.{UnitPoint, RectAnchorSource}

  def cast({:point = type, unit_point}) do
    with {:ok, unit_point} <- UnitPoint.cast(unit_point) do
      {:ok, %__MODULE__{ type: type, properties: unit_point }}
    else
      _ ->
        :error
    end
  end

  def cast({:rect = type, rect}) do
    with {:ok, rect} <- RectAnchorSource.cast(rect) do
      {:ok, %__MODULE__{ type: type, properties: rect }}
    else
      _ ->
        :error
    end
  end

  def cast(_), do: :error
end
