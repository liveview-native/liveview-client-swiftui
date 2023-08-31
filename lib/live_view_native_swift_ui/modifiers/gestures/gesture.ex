defmodule LiveViewNativeSwiftUi.Modifiers.OnTapGesture do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.Gesture
  alias LiveViewNativePlatform.Modifier.Types.Event

  modifier_schema "gesture" do
    field :gesture, Gesture
    field :action, Event
    field :priority, Ecto.Enum, values: ~w(low high simultaneous)a, default: :low
    field :mask, Ecto.Enum, values: ~w(none gesture subviews all)a, default: :all
  end

  def params(gesture, params), do: [{:gesture, gesture} | params]
  def params(params), do: params
end
