defmodule LiveViewNativeSwiftUi.Modifiers.ScrollContentBackground do
  use LiveViewNativePlatform.Modifier

  modifier_schema "scroll_content_background" do
    field :visibility, Ecto.Enum, values: ~w(automatic visible hidden)a
  end
end
