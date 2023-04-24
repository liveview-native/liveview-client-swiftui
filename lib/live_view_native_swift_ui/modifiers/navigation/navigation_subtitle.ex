defmodule LiveViewNativeSwiftUi.Modifiers.NavigationSubtitle do
  use LiveViewNativePlatform.Modifier

  modifier_schema "navigation_subtitle" do
    field :subtitle, :string
  end
end
