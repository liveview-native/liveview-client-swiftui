defmodule LiveViewNativeSwiftUi.Modifiers.FlipsForRightToLeftLayoutDirection do
  use LiveViewNativePlatform.Modifier

  modifier_schema "flips_for_right_to_left_layout_direction" do
    field :enabled, :boolean
  end

  def params(enabled) when is_boolean(enabled), do: [enabled: enabled]
  def params(params), do: params
end
