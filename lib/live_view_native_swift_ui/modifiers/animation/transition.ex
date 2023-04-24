defmodule LiveViewNativeSwiftUi.Modifiers.Transition do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.Transition

  modifier_schema "transition" do
    field :transition, Transition
  end
end
