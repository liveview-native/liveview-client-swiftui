defmodule LiveViewNativeSwiftUi.Modifiers.MultilineTextAlignment do
  use LiveViewNativePlatform.Modifier

  modifier_schema "multiline_text_alignment" do
    field(:alignment, Ecto.Enum, values: ~w(
      center
      leading
      trailing
    )a)
  end

  def params(alignment)
      when is_atom(alignment) and not is_boolean(alignment) and not is_nil(alignment),
      do: [alignment: alignment]

  def params(params), do: params
end
