defmodule LiveViewNativeSwiftUi.Modifiers.TextSelection do
  use LiveViewNativePlatform.Modifier

  modifier_schema "text_selection" do
    field :selectable, :boolean
  end
end
