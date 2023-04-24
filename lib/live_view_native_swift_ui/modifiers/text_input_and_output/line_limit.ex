defmodule LiveViewNativeSwiftUi.Modifiers.LineLimit do
  use LiveViewNativePlatform.Modifier

  modifier_schema "line_limit" do
    field :number, :integer
  end
end
