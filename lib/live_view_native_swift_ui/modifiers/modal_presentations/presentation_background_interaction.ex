defmodule LiveViewNativeSwiftUi.Modifiers.PresentationBackgroundInteraction do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.PresentationDetent

  modifier_schema "presentation_background_interaction" do
    field(:mode, Ecto.Enum, values: ~w(automatic disabled enabled)a)
    field(:maximum_detent, PresentationDetent, default: nil)
  end
end
