defmodule LiveViewNativeSwiftUi.Modifiers.ScrollIndicators do
  use LiveViewNativePlatform.Modifier

  modifier_schema "scroll_indicators" do
    field :visibility, Ecto.Enum, values: ~w(automatic hidden never visible)a
    field :axes, Ecto.Enum, values: [:horizontal, :vertical, :all], default: :all
  end

  def params(visibility, params) when is_list(params), do: [{:visibility, visibility} | params]
  def params(visibility) when is_atom(visibility) and not is_boolean(visibility) and not is_nil(visibility), do: [visibility: visibility]
  def params(params), do: params
end
