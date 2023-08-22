defmodule LiveViewNativeSwiftUi.Modifiers.NavigationTitle do
  use LiveViewNativePlatform.Modifier

  modifier_schema "navigation_title" do
    field :title, :string
  end

  def params(title) when is_binary(title), do: [title: title]
  def params(params), do: params
end
