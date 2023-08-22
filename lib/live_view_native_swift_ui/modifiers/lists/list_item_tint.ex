defmodule LiveViewNativeSwiftUi.Modifiers.ListItemTint do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.ListItemTint

  modifier_schema "list_item_tint" do
    field :tint, ListItemTint
  end

  def params(params) do
    with {:ok, _} <- ListItemTint.cast(params) do
      [tint: params]
    else
      _ ->
        params
    end
  end
end
