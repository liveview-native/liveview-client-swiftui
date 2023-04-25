defmodule LiveViewNativeSwiftUi.Modifiers.SearchSuggestions do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.KeyName

  modifier_schema "search_suggestions" do
    field :suggestions, KeyName
  end
end
