defmodule LiveViewNativeSwiftUi.Modifiers.Frame do
  use LiveViewNativePlatform.Modifier

  modifier_schema "frame" do
    field :width, :float
    field :height, :float
    field :alignment, Ecto.Enum, values: ~w(
      bottom
      bottom_leading
      bottom_trailing
      center
      leading
      leading_last_text_baseline
      top
      top_leading
      top_trailing
      trailing
      trailing_first_text_baseline
    )a
  end
end
