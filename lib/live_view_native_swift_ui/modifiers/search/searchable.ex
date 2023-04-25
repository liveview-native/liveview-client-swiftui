defmodule LiveViewNativeSwiftUi.Modifiers.Searchable do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.NativeBindingName

  modifier_schema "searchable" do
    field :text, NativeBindingName
    field :tokens, NativeBindingName
    field :suggested_tokens, {:array, :string}
    field :placement, Ecto.Enum, values: ~w(automatic navigation_bar_drawer navigation_bar_drawer_always sidebar toolbar)a
    field :prompt, :string
    field :dismiss, :boolean, default: true
  end
end
