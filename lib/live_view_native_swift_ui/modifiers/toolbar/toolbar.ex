defmodule LiveViewNativeSwiftUi.Modifiers.Toolbar do
  use LiveViewNativePlatform.Modifier
  alias LiveViewNativeSwiftUi.Types.KeyName

  modifier_schema "toolbar" do
    field :id, :string
    field :content, KeyName
  end
end
