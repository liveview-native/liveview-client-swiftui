defmodule LiveViewNativeSwiftUi.Modifiers.PresentationContentInteraction do
  use LiveViewNativePlatform.Modifier

  modifier_schema "presentation_content_interaction" do
    field(:interaction, Ecto.Enum, values: ~w(automatic resizes scrolls)a)
  end
end
