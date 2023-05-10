defmodule LiveViewNativeSwiftUi.Modifiers.OnDeleteCommand do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.Event

  modifier_schema "on_delete_command" do
    field :action, Event
  end
end
