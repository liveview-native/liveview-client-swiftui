defmodule LiveViewNativeSwiftUi.Modifiers.Interpolation do
  use LiveViewNativePlatform.Modifier

  modifier_schema "interpolation" do
    field :interpolation, Ecto.Enum, values: ~w(low medium high none)a
  end

  def params(interpolation) when is_atom(interpolation) and not is_boolean(interpolation) and not is_nil(interpolation), do: [interpolation: interpolation]
  def params(params), do: params
end
