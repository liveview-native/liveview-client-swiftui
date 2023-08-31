defmodule LiveViewNativeSwiftUi.Modifiers.OnDeleteCommand do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativePlatform.Modifier.Types.Event

  modifier_schema "on_delete_command" do
    field :perform, Event
  end
end
