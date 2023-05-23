defmodule LiveViewNativeSwiftUi.Modifiers.PersistentSystemOverlays do
  use LiveViewNativePlatform.Modifier

  modifier_schema "persistent_system_overlays" do
    field :visibility, Ecto.Enum, values: ~w(automatic hidden visible)a
  end
end
