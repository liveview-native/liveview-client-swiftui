defmodule LiveViewNativeSwiftUi.Modifiers.TextInputAutocapitalization do
  use LiveViewNativePlatform.Modifier

  modifier_schema "text_input_autocapitalization" do
    field :autocapitalization, Ecto.Enum, values: ~w(
      characters
      sentences
      words
      never
    )a
  end
end
