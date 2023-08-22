defmodule LiveViewNativeSwiftUi.Modifiers.PersistentSystemOverlays do
  use LiveViewNativePlatform.Modifier

  modifier_schema "persistent_system_overlays" do
    field :visibility, Ecto.Enum, values: ~w(automatic hidden visible)a
  end

  def params(visibility) when is_atom(visibility) and not is_boolean(visibility) and not is_nil(visibility), do: [visibility: visibility]
  def params(params), do: params
end
