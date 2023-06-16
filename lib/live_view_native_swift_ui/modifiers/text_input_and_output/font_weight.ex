defmodule LiveViewNativeSwiftUi.Modifiers.FontWeight do
  use LiveViewNativePlatform.Modifier

  modifier_schema "font_weight" do
    field :weight, Ecto.Enum, values: ~w(
      black
      bold
      heavy
      light
      medium
      regular
      semibold
      thin
      ultra_light
    )a
  end

  def params(weight) when is_atom(weight) and not is_boolean(weight) and not is_nil(weight), do: [weight: weight]
  def params(params), do: params
end
