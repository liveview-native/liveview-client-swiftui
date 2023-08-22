defmodule LiveViewNativeSwiftUi.Modifiers.Stroke do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.{ShapeStyle, StrokeStyle}

  modifier_schema "stroke" do
    field :content, ShapeStyle
    field :style, StrokeStyle
  end

  def params(content, params) when is_list(params), do: [{:content, content} | params]
  def params(params) do
    with {:ok, _} <- ShapeStyle.cast(params) do
      [content: params]
    else
      _ ->
        params
    end
  end
end
