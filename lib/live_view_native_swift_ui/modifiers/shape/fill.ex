defmodule LiveViewNativeSwiftUi.Modifiers.Fill do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.{ShapeStyle, FillStyle}

  modifier_schema "fill" do
    field :content, ShapeStyle
    field :style, FillStyle
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
