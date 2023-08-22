defmodule LiveViewNativeSwiftUi.Modifiers.OnAppear do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativePlatform.Types.Event

  modifier_schema "on_appear" do
    field :action, Event
  end
end
