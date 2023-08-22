defmodule LiveViewNativeSwiftUi.Modifiers.ScrollContentBackground do
  use LiveViewNativePlatform.Modifier

  modifier_schema "scroll_content_background" do
    field :visibility, Ecto.Enum, values: ~w(automatic visible hidden)a
  end

  def params(visibility) when is_atom(visibility) and not is_boolean(visibility) and not is_nil(visibility), do: [visibility: visibility]
end
