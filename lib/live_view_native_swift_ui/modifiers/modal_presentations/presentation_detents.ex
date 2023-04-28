defmodule LiveViewNativeSwiftUi.Modifiers.PresentationDetents do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.PresentationDetent

  modifier_schema "presentation_detents" do
    field(:detents, {:array, PresentationDetent})
  end
end
