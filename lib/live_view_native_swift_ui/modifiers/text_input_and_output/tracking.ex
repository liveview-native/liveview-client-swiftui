defmodule LiveViewNativeSwiftUi.Modifiers.Tracking do
  use LiveViewNativePlatform.Modifier

  modifier_schema "tracking" do
    field :tracking, :float
  end

  def params(tracking) when is_number(tracking), do: [tracking: tracking]
  def params(params), do: params
end
