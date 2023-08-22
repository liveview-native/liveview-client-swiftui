defmodule LiveViewNativeSwiftUi.Modifiers.Grayscale do
  use LiveViewNativePlatform.Modifier

  modifier_schema "grayscale" do
    field :amount, :float
  end

  def params(amount) when is_number(amount), do: [amount: amount]
  def params(params), do: params
end
