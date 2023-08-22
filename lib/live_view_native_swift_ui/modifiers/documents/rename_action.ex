defmodule LiveViewNativeSwiftUi.Modifiers.RenameAction do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativePlatform.Modifier.Types.Event

  modifier_schema "rename_action" do
    field :action, Event
  end

  def params(params) do
    with {:ok, _} <- Event.cast(params) do
      [action: params]
    else
      _ ->
        params
    end
  end
end
