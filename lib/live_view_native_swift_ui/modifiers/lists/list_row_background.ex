defmodule LiveViewNativeSwiftUi.Modifiers.ListRowBackground do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.KeyName

  modifier_schema "list_row_background" do
    field :content, KeyName
  end

  def params(params) do
    with {:ok, _} <- KeyName.cast(params) do
      [content: params]
    else
      _ ->
        params
    end
  end
end
