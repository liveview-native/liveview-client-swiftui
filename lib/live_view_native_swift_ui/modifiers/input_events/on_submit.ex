defmodule LiveViewNativeSwiftUi.Modifiers.OnSubmit do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.SubmitTriggers
  alias LiveViewNativeSwiftUi.Types.Event

  modifier_schema "on_submit" do
    field :triggers, SubmitTriggers
    field :action, Event
  end
end
