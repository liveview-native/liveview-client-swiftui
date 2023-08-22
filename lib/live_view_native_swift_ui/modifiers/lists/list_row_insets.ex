defmodule LiveViewNativeSwiftUi.Modifiers.ListRowInsets do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.EdgeInsets

  modifier_schema "list_row_insets" do
    field :insets, EdgeInsets
  end

  def params(params) do
    with {:ok, _} <- EdgeInsets.cast(params) do
      [insets: params]
    else
      _ ->
        params
    end
  end
end
