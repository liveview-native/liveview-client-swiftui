defmodule LiveViewNativeSwiftUi.Modifiers.Tint do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.Color

  modifier_schema "tint" do
    field :color, Color
  end

  def params(params) do
    with {:ok, _} <- Color.cast(params) do
      [color: params]
    else
      _ ->
        params
    end
  end
end
