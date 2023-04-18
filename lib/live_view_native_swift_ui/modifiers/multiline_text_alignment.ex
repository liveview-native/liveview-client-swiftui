defmodule LiveViewNativeSwiftUi.Modifiers.MultilineTextAlignment do
  use LiveViewNativePlatform.Modifier

  modifier_schema "multiline_text_alignment" do
    field :alignment, Ecto.Enum, values: ~w(
      center
      leading
      trailing
    )a
  end
end

