defmodule LiveViewNativeSwiftUi.Modifiers.OnAppear do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativePlatform.Modifier.Types.Event

  modifier_schema "on_appear" do
    field :perform, Event
  end
end
