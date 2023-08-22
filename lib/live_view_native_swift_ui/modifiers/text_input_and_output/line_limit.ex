defmodule LiveViewNativeSwiftUi.Modifiers.LineLimit do
  use LiveViewNativePlatform.Modifier

  modifier_schema "line_limit" do
    field :number, :integer
  end

  def params(number) when is_integer(number), do: [number: number]
  def params(params), do: params
end
