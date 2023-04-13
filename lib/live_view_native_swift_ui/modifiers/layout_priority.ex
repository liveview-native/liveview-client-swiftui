defmodule LiveViewNativeSwiftUi.Modifiers.LayoutPriority do
  use LiveViewNativePlatform.Modifier

  modifier_schema "layout_priority" do
    field :value, :float
  end
end