defmodule LiveViewNativeSwiftUi.Modifiers.DefersSystemGestures do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.EdgeSet

  modifier_schema "defers_system_gestures" do
    field :edges, EdgeSet
  end
end
