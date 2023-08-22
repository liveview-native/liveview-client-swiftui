defmodule LiveViewNativeSwiftUi.Modifiers.DefersSystemGestures do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.EdgeSet

  modifier_schema "defers_system_gestures" do
    field :edges, EdgeSet
  end

  def params([on: edges]), do: [edges: edges]
  def params(params), do: params
end
