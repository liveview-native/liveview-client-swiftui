defmodule LiveViewNativeSwiftUi.Modifiers.LineSpacing do
  use LiveViewNativePlatform.Modifier

  modifier_schema "line_spacing" do
    field :line_spacing, :float
  end
end

