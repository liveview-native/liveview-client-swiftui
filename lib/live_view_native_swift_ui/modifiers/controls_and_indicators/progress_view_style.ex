defmodule LiveViewNativeSwiftUi.Modifiers.ProgressViewStyle do
  use LiveViewNativePlatform.Modifier

  modifier_schema "progress_view_style" do
    field(:style, Ecto.Enum, values: ~w(
      automatic
      linear
      circular
    )a)
  end

  def params(style) when is_atom(style) and not is_boolean(style) and not is_nil(style), do: [style: style]
  def params(params), do: params
end
