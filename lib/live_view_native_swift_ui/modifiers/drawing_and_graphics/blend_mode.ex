defmodule LiveViewNativeSwiftUi.Modifiers.BlendMode do
  use LiveViewNativePlatform.Modifier

  modifier_schema "blend_mode" do
    field(:blend_mode, Ecto.Enum, values: ~w(
      normal
      darken
      multiply
      color_burn
      plus_darker
      lighten
      screen
      color_dodge
      plus_lighter
      overlay
      soft_light
      hard_light
      difference
      exclusion
      hue
      saturation
      color
      luminosity
      source_atop
      destination_over
      destination_out
    )a)
  end
end
