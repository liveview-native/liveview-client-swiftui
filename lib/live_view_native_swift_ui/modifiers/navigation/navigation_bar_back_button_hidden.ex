defmodule LiveViewNativeSwiftUi.Modifiers.NavigationBarBackButtonHidden do
  use LiveViewNativePlatform.Modifier

  modifier_schema "navigation_bar_back_button_hidden" do
    field :hides_back_button, :boolean, default: true
  end

  def params(hides_back_button) when is_boolean(hides_back_button), do: [hides_back_button: hides_back_button]
  def params(params), do: params
end
