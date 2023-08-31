defmodule LiveViewNativeSwiftUi.Modifiers.PresentationContentInteraction do
  use LiveViewNativePlatform.Modifier

  modifier_schema "presentation_content_interaction" do
    field(:interaction, Ecto.Enum, values: ~w(automatic resizes scrolls)a)
  end

  def params(interaction) when is_atom(interaction) and not is_boolean(interaction) and not is_nil(interaction), do: [interaction: interaction]
  def params(params), do: params
end
