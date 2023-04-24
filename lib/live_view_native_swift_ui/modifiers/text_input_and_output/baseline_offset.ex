defmodule LiveViewNativeSwiftUi.Modifiers.BaselineOffset do
  use LiveViewNativePlatform.Modifier

  modifier_schema "baseline_offset" do
    field :offset, :float
  end
end
