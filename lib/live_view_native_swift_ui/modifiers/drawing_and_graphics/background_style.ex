defmodule LiveViewNativeSwiftUi.Modifiers.BackgroundStyle do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.ShapeStyle

  modifier_schema "background_style" do
    field :style, ShapeStyle
  end

  def params(params) do
    with {:ok, _} <- ShapeStyle.cast(params) do
      [style: params]
    else
      _ ->
        params
    end
  end
end
