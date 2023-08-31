defmodule LiveViewNativeSwiftUi.Modifiers.OnMoveCommand do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativePlatform.Modifier.Types.Event

  modifier_schema "on_move_command" do
    field :action, Event
  end
end
