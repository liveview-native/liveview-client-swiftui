defmodule LiveViewNativeSwiftUi.Modifiers.TextSelection do
  use LiveViewNativePlatform.Modifier

  modifier_schema "text_selection" do
    field :selectable, :boolean
  end

  def params(selectable) when is_boolean(selectable), do: [selectable: selectable]
  def params(params), do: params
end
