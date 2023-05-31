defmodule LiveViewNativeSwiftUi.Modifiers.PresentationDetents do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.{PresentationDetent, NativeBindingName}

  modifier_schema "presentation_detents" do
    field :detents, {:array, PresentationDetent}
    field :selection, NativeBindingName, default: nil
  end
end
