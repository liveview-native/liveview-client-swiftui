defmodule LiveViewNativeSwiftUi.Modifiers.Badge do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.KeyName

  modifier_schema "badge" do
    field :content, KeyName
    field :label, :string
    field :count, :integer
  end
end
