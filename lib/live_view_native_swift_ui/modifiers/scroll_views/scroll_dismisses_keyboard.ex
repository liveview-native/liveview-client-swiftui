defmodule LiveViewNativeSwiftUi.Modifiers.ScrollDismissesKeyboard do
  use LiveViewNativePlatform.Modifier

  modifier_schema "scroll_dismisses_keyboard" do
    field :mode, Ecto.Enum, values: ~w(
        automatic
        immediately
        interactively
        never
    )a
  end

  def params(mode) when is_atom(mode) and not is_boolean(mode) and not is_nil(mode), do: [mode: mode]
  def params(params), do: params
end
