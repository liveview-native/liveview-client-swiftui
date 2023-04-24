defmodule LiveViewNativeSwiftUi.Modifiers.NavigationBarBackButtonHidden do
  use LiveViewNativePlatform.Modifier

  modifier_schema "navigation_bar_back_button_hidden" do
    field :hides_back_button, :boolean, default: true
  end
end

