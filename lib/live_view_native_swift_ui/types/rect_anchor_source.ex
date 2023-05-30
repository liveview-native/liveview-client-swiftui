defmodule LiveViewNativeSwiftUi.Types.RectAnchorSource do
  @derive Jason.Encoder
  defstruct [
    :type,
    :properties
  ]

  use LiveViewNativePlatform.Modifier.Type
  def type, do: :map

  alias LiveViewNativeSwiftUi.Types.Rect

  def cast({:rect = type, rect}) do
    with {:ok, rect} <- Rect.cast(rect) do
      {:ok, %__MODULE__{ type: type, properties: rect }}
    else
      _ ->
        :error
    end
  end

  def cast(:bounds = type) do
    {:ok, %__MODULE__{ type: type, properties: %{} }}
  end

  def cast(_), do: :error
end
