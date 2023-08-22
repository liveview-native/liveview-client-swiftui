defmodule LiveViewNativeSwiftUi.Modifiers.RenderingMode do
  use LiveViewNativePlatform.Modifier

  modifier_schema "rendering_mode" do
    field :mode, Ecto.Enum, values: ~w(original template)a
  end

  def params(mode) when is_atom(mode) and not is_boolean(mode) and not is_nil(mode), do: [mode: mode]
  def params(params), do: params
end
