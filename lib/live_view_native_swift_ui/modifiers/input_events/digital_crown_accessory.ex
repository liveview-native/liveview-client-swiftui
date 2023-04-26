defmodule LiveViewNativeSwiftUi.Modifiers.DigitalCrownAccessory do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.KeyName

  modifier_schema "digital_crown_accessory" do
    field :content, KeyName
  end
end
