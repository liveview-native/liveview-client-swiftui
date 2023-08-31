defmodule LiveViewNativeSwiftUi.Modifiers.Font do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.Font

  modifier_schema "font" do
    field :font, Font
  end

  def params(params) do
    with {:ok, _} <- Font.cast(params) do
      [font: params]
    else
      _ ->
        params
    end
  end
end
