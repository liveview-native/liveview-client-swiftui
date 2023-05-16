defmodule LiveViewNativeSwiftUi.Modifiers.PrivacySensitive do
  use LiveViewNativePlatform.Modifier

  modifier_schema "privacy_sensitive" do
    field :sensitive, :boolean
  end
end
