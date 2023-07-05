defmodule LiveViewNativeSwiftUi.Modifiers.ImageScale do
  use LiveViewNativePlatform.Modifier

  modifier_schema "image_scale" do
    field :scale, Ecto.Enum, values: ~w(small medium large)a
  end

  def params(scale) when is_atom(scale) and not is_boolean(scale) and not is_nil(scale), do: [scale: scale]
  def params(params), do: params
end
