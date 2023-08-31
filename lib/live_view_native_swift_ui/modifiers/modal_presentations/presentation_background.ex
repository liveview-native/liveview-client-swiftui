defmodule LiveViewNativeSwiftUi.Modifiers.PresentationBackground do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.{KeyName, ShapeStyle}

  modifier_schema "presentation_background" do
    field(:style, ShapeStyle, default: nil)

    field(:alignment, Ecto.Enum,
      values: ~w(
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
    )a,
      default: :center
    )

    field(:content, KeyName, default: nil)
  end

  def params(style) when is_atom(style) and not is_boolean(style) and not is_nil(style), do: [style: style]
  def params(params), do: params
end
