defmodule LiveViewNativeSwiftUi.Modifiers.FindNavigator do
  use LiveViewNativePlatform.Modifier

  modifier_schema "find_navigator" do
    field :is_presented, :boolean

    change_event()
  end
end
