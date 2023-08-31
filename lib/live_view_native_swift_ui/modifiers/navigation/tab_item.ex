defmodule LiveViewNativeSwiftUi.Modifiers.TabItem do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.KeyName

  modifier_schema "tab_item" do
    field :label, KeyName
  end

  def params(params) do
    with {:ok, _} <- KeyName.cast(params) do
      [label: params]
    else
      _ ->
        params
    end
  end
end
