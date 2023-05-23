defmodule LiveViewNativeSwiftUi.Modifiers.PresentationCompactAdaptation do
  use LiveViewNativePlatform.Modifier

  @adaptations ~w(automatic none popover sheet full_screen_cover)a

  modifier_schema "presentation_compact_adaptation" do
    field :horizontal, Ecto.Enum, values: @adaptations
    field :vertical, Ecto.Enum, values: @adaptations
  end
end
