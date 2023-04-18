defmodule LiveViewNativeSwiftUi.Modifiers.MinimumScaleFactor do
  use LiveViewNativePlatform.Modifier

  modifier_schema "minimum_scale_factor" do
    field :factor, :float
  end
end

