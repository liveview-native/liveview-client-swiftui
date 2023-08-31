defmodule LiveViewNativeSwiftUi.Modifiers.OnDisappear do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativePlatform.Modifier.Types.Event

  modifier_schema "on_disappear" do
    field :perform, Event
  end
end
