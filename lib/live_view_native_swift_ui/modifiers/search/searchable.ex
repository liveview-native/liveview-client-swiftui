defmodule LiveViewNativeSwiftUi.Modifiers.Searchable do
  use LiveViewNativePlatform.Modifier

  modifier_schema "searchable" do
    field :text, :string
    field :tokens, {:array, :string}, default: []
    field :suggested_tokens, {:array, :string}
    field :placement, Ecto.Enum, values: ~w(automatic navigation_bar_drawer navigation_bar_drawer_always sidebar toolbar)a
    field :prompt, :string
    field :dismiss, :boolean, default: true

    change_event()
  end
end
