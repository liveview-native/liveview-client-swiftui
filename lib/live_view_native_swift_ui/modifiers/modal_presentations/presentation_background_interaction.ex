defmodule LiveViewNativeSwiftUi.Modifiers.PresentationBackgroundInteraction do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.PresentationDetent

  modifier_schema "presentation_background_interaction" do
    field(:mode, Ecto.Enum, values: ~w(automatic disabled enabled)a)
    field(:maximum_detent, PresentationDetent, default: nil)
  end

  def params(mode) when is_atom(mode) and not is_boolean(mode) and not is_nil(mode), do: [mode: mode]
  def params({:enabled = mode, [up_through: maximum_detent]}), do: [mode: mode, maximum_detent: maximum_detent]
  def params(params), do: params
end
