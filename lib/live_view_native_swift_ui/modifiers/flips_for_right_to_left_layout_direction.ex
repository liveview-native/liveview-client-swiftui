defmodule LiveViewNativeSwiftUi.Modifiers.FlipsForRightToLeftLayoutDirection do
  use LiveViewNativePlatform.Modifier

  modifier_schema "flips_for_right_to_left_layout_direction" do
    field :enabled, :boolean
  end
end
