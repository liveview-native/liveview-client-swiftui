defmodule LiveViewNativeSwiftUi.Modifiers.Refreshable do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativePlatform.Types.Event

  modifier_schema "refreshable" do
    field :action, Event
  end
end
