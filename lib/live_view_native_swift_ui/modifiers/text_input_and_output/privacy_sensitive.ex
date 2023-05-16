defmodule LiveViewNativeSwiftUi.Modifiers.PrivacySensitive do
  use LiveViewNativePlatform.Modifier

  modifier_schema "privacy_sensitive" do
    field :sensitive, Ecto.Enum, values: ~w(true false)a
  end
end
