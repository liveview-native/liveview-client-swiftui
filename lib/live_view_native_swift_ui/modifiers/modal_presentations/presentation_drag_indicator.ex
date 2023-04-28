defmodule LiveViewNativeSwiftUi.Modifiers.PresentationDragIndicator do
  use LiveViewNativePlatform.Modifier

  modifier_schema "presentation_drag_indicator" do
    field(:visibility, Ecto.Enum, values: ~w(automatic visible hidden)a)
  end
end
