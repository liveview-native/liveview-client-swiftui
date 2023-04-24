defmodule LiveViewNativeSwiftUi.Modifiers.Tracking do
  use LiveViewNativePlatform.Modifier

  modifier_schema "tracking" do
    field :tracking, :float
  end
end
