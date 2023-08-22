defmodule LiveViewNativeSwiftUi.Modifiers.OnDisappear do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativePlatform.Types.Event

  modifier_schema "on_disappear" do
    field :action, Event
  end
end
