defmodule LiveViewNativeSwiftUi.Modifiers.Inset do
  use LiveViewNativePlatform.Modifier

  modifier_schema "inset" do
    field :amount, :float
  end

  def params([by: amount]), do: [amount: amount]
  def params(params), do: params
end
