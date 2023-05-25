defmodule LiveViewNativeSwiftUi.Modifiers.FindNavigator do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.NativeBindingName

  modifier_schema "find_navigator" do
    field :is_presented, NativeBindingName
  end
end
