defmodule LiveViewNativeSwiftUi.Modifiers.FontDesign do
  use LiveViewNativePlatform.Modifier

  modifier_schema "font_design" do
    field :design, Ecto.Enum, values: ~w(
      default
      monospaced
      rounded
      serif
    )a
  end

  def params(design) when is_atom(design) and not is_boolean(design) and not is_nil(design), do: [design: design]
  def params(params), do: params
end
