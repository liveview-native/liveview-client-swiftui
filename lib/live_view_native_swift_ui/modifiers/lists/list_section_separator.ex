defmodule LiveViewNativeSwiftUi.Modifiers.ListSectionSeparator do
  use LiveViewNativePlatform.Modifier

  modifier_schema "list_section_separator" do
    field :visibility, Ecto.Enum, values: ~w(automatic hidden visible)a
    field :edges, Ecto.Enum, values: ~w(all bottom top)a, default: :all
  end

  def params(visibility, [edges: edges]), do: [visibility: visibility, edges: edges]
  def params(visibility) when is_atom(visibility) and not is_boolean(visibility) and not is_nil(visibility), do: [visibility: visibility]
  def params(params), do: params
end
