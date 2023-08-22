defmodule LiveViewNativeSwiftUi.Modifiers.Trim do
  use LiveViewNativePlatform.Modifier

  modifier_schema "trim" do
    field :start_fraction, :float, default: 0.0
    field :end_fraction, :float, default: 1.0
  end

  def params([from: start_fraction, to: end_fraction]), do: [start_fraction: start_fraction, end_fraction: end_fraction]
  def params(params), do: params
end
