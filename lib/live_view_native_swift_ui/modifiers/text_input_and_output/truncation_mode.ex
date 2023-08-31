defmodule LiveViewNativeSwiftUi.Modifiers.TruncationMode do
  use LiveViewNativePlatform.Modifier

  modifier_schema "truncation_mode" do
    field :mode, Ecto.Enum, values: ~w(
      head
      middle
      tail
    )a
  end

  def params(mode) when is_atom(mode) and not is_boolean(mode) and not is_nil(mode), do: [mode: mode]
  def params(params), do: params
end
