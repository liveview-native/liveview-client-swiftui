defmodule LiveViewNativeSwiftUi.Modifiers.Help do
  use LiveViewNativePlatform.Modifier

  modifier_schema "help" do
    field :text, :string
  end

  def params(text) when is_binary(text), do: [text: text]
  def params(params), do: params
end
