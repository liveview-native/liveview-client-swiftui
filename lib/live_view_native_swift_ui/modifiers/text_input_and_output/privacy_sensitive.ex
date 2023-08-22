defmodule LiveViewNativeSwiftUi.Modifiers.PrivacySensitive do
  use LiveViewNativePlatform.Modifier

  modifier_schema "privacy_sensitive" do
    field :sensitive, :boolean
  end

  def params(sensitive) when is_boolean(sensitive), do: [sensitive: sensitive]
  def params(params), do: params
end
