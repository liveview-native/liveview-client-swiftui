defmodule LiveViewNativeSwiftUi.Modifiers.Mask do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.KeyName

  modifier_schema "mask" do
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
    )a, default: :center
    field :mask, KeyName
  end
end
