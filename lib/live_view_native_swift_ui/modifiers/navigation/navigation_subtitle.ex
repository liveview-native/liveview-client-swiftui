defmodule LiveViewNativeSwiftUi.Modifiers.NavigationSubtitle do
  use LiveViewNativePlatform.Modifier

  modifier_schema "navigation_subtitle" do
    field :subtitle, :string
  end

  def params(subtitle) when is_binary(subtitle), do: [subtitle: subtitle]
  def params(params), do: params
end
