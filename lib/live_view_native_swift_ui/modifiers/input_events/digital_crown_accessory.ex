defmodule LiveViewNativeSwiftUi.Modifiers.DigitalCrownAccessory do
  use LiveViewNativePlatform.Modifier

  modifier_schema "digital_crown_accessory" do
    field :visibility, Ecto.Enum, values: ~w(automatic visible hidden)a
  end
end
