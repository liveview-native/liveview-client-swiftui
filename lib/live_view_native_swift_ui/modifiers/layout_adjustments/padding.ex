defmodule LiveViewNativeSwiftUi.Modifiers.Padding do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.EdgeInsets
  alias LiveViewNativeSwiftUi.Types.EdgeSet

  modifier_schema "padding" do
    field :insets, EdgeInsets
    field :edges, EdgeSet
    field :length, :float
  end

  def params(), do: []

  def params(edges, length) when is_atom(edges) or is_list(edges), do: [edges: edges, length: length]

  def params(length) when is_number(length), do: [length: length]
  def params(edges) when is_atom(edges), do: [edges: edges]
  def params([e | _] = edges) when is_atom(e), do: [edges: edges]
  def params([{k, v} | _] = insets) when is_atom(k) and is_number(v), do: [insets: insets]
  def params(insets) when is_map(insets), do: [insets: insets]

  def params(params), do: params
end
