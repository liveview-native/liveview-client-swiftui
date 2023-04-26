defmodule LiveViewNativeSwiftUi.Modifiers.ButtonBorderShape do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.ButtonBorderShape

  modifier_schema "button_border_shape" do
    field(:shape, Ecto.Enum, values: ~w(automatic capsule rounded_rectangle)a)
    field(:radius, :float, default: nil)
  end
end
