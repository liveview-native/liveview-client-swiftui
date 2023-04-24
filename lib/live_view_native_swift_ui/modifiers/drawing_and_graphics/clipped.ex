defmodule LiveViewNativeSwiftUi.Modifiers.Clipped do
  use LiveViewNativePlatform.Modifier

  modifier_schema "clipped" do
    field :antialiased, :boolean, default: false
  end
end

