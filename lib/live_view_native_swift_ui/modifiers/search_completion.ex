defmodule LiveViewNativeSwiftUi.Modifiers.SearchCompletion do
  use LiveViewNativePlatform.Modifier

  modifier_schema "search_completion" do
    field :completion, :string
    field :token, :string
  end
end
