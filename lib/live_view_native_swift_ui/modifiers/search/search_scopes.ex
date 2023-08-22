defmodule LiveViewNativeSwiftUi.Modifiers.SearchScopes do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.KeyName

  modifier_schema "search_scopes" do
    field :active, :string
    field :activation, Ecto.Enum, values: ~w(automatic on_search_presentation on_text_entry)a
    field :scopes, KeyName

    change_event()
  end
end
