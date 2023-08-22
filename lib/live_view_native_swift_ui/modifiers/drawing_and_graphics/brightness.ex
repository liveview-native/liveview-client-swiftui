defmodule LiveViewNativeSwiftUi.Modifiers.Brightness do
  use LiveViewNativePlatform.Modifier

  modifier_schema "brightness" do
    field :amount, :float
  end

  def params(amount) when is_number(amount), do: [amount: amount]
  def params(params), do: params
end
