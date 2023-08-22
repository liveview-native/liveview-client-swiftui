defmodule LiveViewNativeSwiftUi.Modifiers.OnSubmit do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.SubmitTriggers
  alias LiveViewNativePlatform.Modifier.Types.Event

  modifier_schema "on_submit" do
    field :triggers, SubmitTriggers
    field :action, Event
  end

  def params([of: triggers], action), do: [triggers: triggers, action: action]
  def params(params) do
    with {:ok, _} <- Event.cast(params) do
      [action: params]
    else
      _ ->
        params
    end
  end
end
