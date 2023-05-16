defmodule LiveViewNativeSwiftUi.Modifiers.Trim do
  use LiveViewNativePlatform.Modifier

  modifier_schema "trim" do
    field :start_fraction, :float, default: 0.0
    field :end_fraction, :float, default: 1.0
  end
end
