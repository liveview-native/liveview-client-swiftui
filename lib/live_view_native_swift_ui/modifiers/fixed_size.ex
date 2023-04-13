defmodule LiveViewNativeSwiftUi.Modifiers.FixedSize do
  use LiveViewNativePlatform.Modifier

  modifier_schema "fixed_size" do
    field :horizontal, :boolean
    field :vertical, :boolean
  end
end
