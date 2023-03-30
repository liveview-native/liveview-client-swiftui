defmodule LiveViewNativeSwiftUi.Modifiers.Toolbar do
  use LiveViewNativePlatform.Modifier

  modifier_schema "toolbar" do
    field :id, :string
    field :content, :string
  end
end
