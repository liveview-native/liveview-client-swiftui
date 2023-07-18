defmodule LiveViewNativeSwiftUi.Modifiers.ScenePadding do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.EdgeSet

  modifier_schema "scene_padding" do
    field :padding, Ecto.Enum, values: ~w(automatic minimum navigation_bar)a, default: :automatic
    field :edges, EdgeSet
  end

  def params(padding, [edges: edges]), do: [padding: padding, edges: edges]
  def params(padding) when is_atom(padding) and not is_boolean(padding) and not is_nil(padding), do: [padding: padding]
  def params(params), do: params
end
