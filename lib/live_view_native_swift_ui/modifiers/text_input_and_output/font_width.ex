defmodule LiveViewNativeSwiftUi.Modifiers.FontWidth do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.FontWidth

  modifier_schema "font_width" do
    field :width, FontWidth
  end

  def params(params) do
    with {:ok, _} <- FontWidth.cast(params) do
      [width: params]
    else
      _ ->
        params
    end
  end
end
