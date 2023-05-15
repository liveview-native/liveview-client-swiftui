defmodule LiveViewNativeSwiftUi.Modifiers.ToolbarTitleMenu do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.KeyName

  modifier_schema "toolbar_title_menu" do
    field :content, KeyName
  end
end
