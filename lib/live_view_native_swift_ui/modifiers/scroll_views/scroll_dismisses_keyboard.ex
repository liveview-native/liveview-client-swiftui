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
end
