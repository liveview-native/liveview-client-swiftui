defmodule LiveViewNativeSwiftUi.Modifiers.Kerning do
  use LiveViewNativePlatform.Modifier

  modifier_schema "kerning" do
    field :kerning, :float
  end
end

