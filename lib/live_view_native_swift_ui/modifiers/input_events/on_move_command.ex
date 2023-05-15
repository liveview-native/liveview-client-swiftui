defmodule LiveViewNativeSwiftUi.Modifiers.OnMoveCommand do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.Event

  modifier_schema "on_move_command" do
    field :action, Event
  end
end
