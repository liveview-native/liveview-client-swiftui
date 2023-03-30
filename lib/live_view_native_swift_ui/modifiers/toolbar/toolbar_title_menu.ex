defmodule LiveViewNativeSwiftUi.Modifiers.ToolbarTitleMenu do
  use LiveViewNativePlatform.Modifier

  modifier_schema "toolbar_title_menu" do
    field :content, :string
  end
end
