defmodule LiveViewNativeSwiftUi.Modifiers.LineSpacing do
  use LiveViewNativePlatform.Modifier

  modifier_schema "line_spacing" do
    field :line_spacing, :float
  end

  def params(line_spacing) when is_number(line_spacing), do: [line_spacing: line_spacing]
  def params(params), do: params
end
