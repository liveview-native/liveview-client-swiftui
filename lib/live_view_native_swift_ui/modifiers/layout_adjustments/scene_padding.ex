defmodule LiveViewNativeSwiftUi.Modifiers.ScenePadding do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.EdgeSet

  modifier_schema "scene_padding" do
    field :padding, Ecto.Enum, values: ~w(automatic minimum navigation_bar)a, default: :automatic
    field :edges, EdgeSet
  end
end
