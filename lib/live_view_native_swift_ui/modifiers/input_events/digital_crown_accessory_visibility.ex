defmodule LiveViewNativeSwiftUi.Modifiers.DigitalCrownAccessoryVisibility do
  use LiveViewNativePlatform.Modifier

  modifier_schema "digital_crown_accessory_visibility" do
    field :visibility, Ecto.Enum, values: ~w(automatic visible hidden)a
  end
end
