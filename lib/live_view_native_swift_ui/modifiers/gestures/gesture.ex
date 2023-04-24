defmodule LiveViewNativeSwiftUi.Modifiers.OnTapGesture do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.Gesture
  alias LiveViewNativeSwiftUi.Types.Event

  modifier_schema "gesture" do
    field :gesture, Gesture
    field :action, Event
    field :priority, Ecto.Enum, values: ~w(low high simultaneous)a, default: :low
    field :mask, Ecto.Enum, values: ~w(none gesture subviews all)a, default: :all
  end
end
