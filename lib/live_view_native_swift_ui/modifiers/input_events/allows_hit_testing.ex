defmodule LiveViewNativeSwiftUi.Modifiers.AllowsHitTesting do
  use LiveViewNativePlatform.Modifier

  modifier_schema "allows_hit_testing" do
    field :enabled, :boolean
  end
end
