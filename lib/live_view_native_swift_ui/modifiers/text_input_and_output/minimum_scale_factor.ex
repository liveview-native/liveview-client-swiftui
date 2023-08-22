defmodule LiveViewNativeSwiftUi.Modifiers.MinimumScaleFactor do
  use LiveViewNativePlatform.Modifier

  modifier_schema "minimum_scale_factor" do
    field :factor, :float
  end

  def params(factor) when is_number(factor), do: [factor: factor]
  def params(params), do: params
end
