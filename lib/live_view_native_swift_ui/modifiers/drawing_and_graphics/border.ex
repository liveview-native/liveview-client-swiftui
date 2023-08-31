defmodule LiveViewNativeSwiftUi.Modifiers.Border do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.ShapeStyle

  modifier_schema "border" do
    field :content, ShapeStyle
    field :width, :float, default: 1.0
  end

  def params(content, [width: width]), do: [content: content, width: width]
  def params(params) do
    with {:ok, _} <- ShapeStyle.cast(params) do
      [content: params, width: 1.0]
    else
      _ ->
        params
    end
  end
end
