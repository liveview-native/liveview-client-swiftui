defmodule LiveViewNativeSwiftUi.Modifiers.TextCase do
  use LiveViewNativePlatform.Modifier

  modifier_schema "text_case" do
    field :text_case, Ecto.Enum, values: ~w(lowercase uppercase)a
  end

  def params(text_case) when is_atom(text_case) and not is_boolean(text_case) and not is_nil(text_case), do: [text_case: text_case]
  def params(params), do: params
end
