defmodule LiveViewNativeSwiftUi.Modifiers.SearchScopes do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.KeyName
  alias LiveViewNativeSwiftUi.Types.NativeBindingName

  modifier_schema "search_scopes" do
    field :active, NativeBindingName
    field :activation, Ecto.Enum, values: ~w(automatic on_search_presentation on_text_entry)a
    field :scopes, KeyName
  end
end
