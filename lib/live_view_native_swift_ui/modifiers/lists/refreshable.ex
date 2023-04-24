defmodule LiveViewNativeSwiftUi.Modifiers.Refreshable do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.Event

  modifier_schema "refreshable" do
    field :action, Event
  end
end
