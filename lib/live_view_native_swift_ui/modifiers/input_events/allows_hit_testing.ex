defmodule LiveViewNativeSwiftUi.Modifiers.AllowsHitTesting do
  use LiveViewNativePlatform.Modifier

  modifier_schema "allows_hit_testing" do
    field :enabled, :boolean
  end

  def params(enabled) when is_boolean(enabled), do: [enabled: enabled]
  def params(params), do: params
end
