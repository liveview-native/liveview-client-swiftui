defmodule LiveViewNativeSwiftUi.Modifiers.StatusBarHidden do
  use LiveViewNativePlatform.Modifier

  modifier_schema "status_bar_hidden" do
    field :hidden, :boolean
  end
end
