defmodule LiveViewNativeSwiftUi.Types.ImagePaint do
  @derive Jason.Encoder
  defstruct [
    :image,
    :system_image,
    :source_rect,
    :scale
  ]

  use LiveViewNativePlatform.Modifier.Type
  def type, do: :map

  alias LiveViewNativeSwiftUi.Types.Rect

  def cast(value) when is_map(value) or is_list(value) do
    with {:ok, source_rect} <- Rect.cast(value[:source_rect] || [x: 0, y: 0, width: 1, height: 1]) do
      case value[:image] do
        {:name, image} ->
          {:ok, %__MODULE__{
            image: image,
            system_image: nil,
            source_rect: source_rect,
            scale: value[:scale] || 1
          }}
        {:system, system_image} ->
          {:ok, %__MODULE__{
            image: nil,
            system_image: system_image,
            source_rect: source_rect,
            scale: value[:scale] || 1
          }}
      end
    else
      _ ->
        :error
    end
  end

  def cast(_), do: :error
end
