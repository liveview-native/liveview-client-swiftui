defmodule LiveViewNativeSwiftUi.Modifiers.OnHover do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.Event

  modifier_schema "on_hover" do
    field :action, Event
  end
end
