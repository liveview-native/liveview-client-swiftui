defmodule LiveViewNativeSwiftUi.Modifiers.DropDestination do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativePlatform.Modifier.Types.Event

  modifier_schema "drop_destination" do
    field :action, Event
    field :is_targeted, Event
  end
end
