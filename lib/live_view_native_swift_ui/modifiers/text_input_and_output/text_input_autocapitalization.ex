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

  def params(autocapitalization) when is_atom(autocapitalization) and not is_boolean(autocapitalization) and not is_nil(autocapitalization), do: [autocapitalization: autocapitalization]
  def params(params), do: params
end
