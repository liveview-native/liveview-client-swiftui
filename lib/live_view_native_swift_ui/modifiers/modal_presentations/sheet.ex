defmodule LiveViewNativeSwiftUi.Modifiers.Sheet do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.KeyName
  alias LiveViewNativePlatform.Modifier.Types.Event

  modifier_schema "sheet" do
    field(:is_presented, :boolean)
    field(:on_dismiss, Event, default: nil)
    field(:content, KeyName)

    change_event()
  end
end
