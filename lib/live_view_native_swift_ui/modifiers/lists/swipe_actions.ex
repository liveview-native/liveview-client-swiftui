defmodule LiveViewNativeSwiftUi.Modifiers.SwipeActions do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.KeyName

  modifier_schema "swipe_actions" do
    field :allows_full_swipe, :boolean, default: true
    field :content, KeyName
    field :edge, Ecto.Enum, values: ~w(leading trailing)a, default: :trailing
  end
end
