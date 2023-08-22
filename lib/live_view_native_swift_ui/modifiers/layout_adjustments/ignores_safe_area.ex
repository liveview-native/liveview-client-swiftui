defmodule LiveViewNativeSwiftUi.Modifiers.IgnoresSafeArea do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.EdgeSet

  modifier_schema "ignores_safe_area" do
    field :regions, Ecto.Enum, values: ~w(all container keyboard)a, default: :all
    field :edges, EdgeSet
  end

  def params(regions, [edges: edges]), do: [regions: regions, edges: edges]
  def params(params), do: params
end
