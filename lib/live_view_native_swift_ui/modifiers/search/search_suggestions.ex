defmodule LiveViewNativeSwiftUi.Modifiers.SearchSuggestions do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.KeyName

  modifier_schema "search_suggestions" do
    field :suggestions, KeyName
  end

  def params(params) do
    with {:ok, _} <- KeyName.cast(params) do
      [suggestions: params]
    else
      _ ->
        params
    end
  end
end
