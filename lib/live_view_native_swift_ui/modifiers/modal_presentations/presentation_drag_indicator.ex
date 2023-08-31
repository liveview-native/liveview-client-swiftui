defmodule LiveViewNativeSwiftUi.Modifiers.PresentationDragIndicator do
  use LiveViewNativePlatform.Modifier

  modifier_schema "presentation_drag_indicator" do
    field(:visibility, Ecto.Enum, values: ~w(automatic visible hidden)a)
  end

  def params(visibility) when is_atom(visibility) and not is_boolean(visibility) and not is_nil(visibility), do: [visibility: visibility]
  def params(params), do: params
end
