defmodule LiveViewNativeSwiftUi.Modifiers.DropDestination do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.Event

  modifier_schema "drop_destination" do
    field :action, Event
    field :is_targeted, Event
  end
end
