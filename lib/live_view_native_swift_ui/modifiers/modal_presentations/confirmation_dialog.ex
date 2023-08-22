defmodule LiveViewNativeSwiftUi.Modifiers.ConfirmationDialog do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.{KeyName}

  modifier_schema "confirmation_dialog" do
    field(:title, :string)

    field(:title_visibility, Ecto.Enum, values: ~w(automatic visible hidden)a, default: :automatic)

    field(:actions, KeyName)
    field(:message, KeyName, default: nil)
    field(:is_presented, :boolean)

    change_event()
  end
end
