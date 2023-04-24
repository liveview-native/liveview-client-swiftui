defmodule LiveViewNativeSwiftUi.Modifiers.NavigationTitle do
  use LiveViewNativePlatform.Modifier

  modifier_schema "navigation_title" do
    field :title, :string
  end
end
