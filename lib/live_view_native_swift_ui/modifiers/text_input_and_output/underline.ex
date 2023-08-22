defmodule LiveViewNativeSwiftUi.Modifiers.Underline do
  use LiveViewNativePlatform.Modifier
  alias LiveViewNativeSwiftUi.Types.Color

  modifier_schema "underline" do
    field :is_active, :boolean, default: true
    field :pattern, Ecto.Enum, values: ~w(dash dash_dot dash_dot_dot dot solid)a, default: :solid
    field :color, Color
  end

  def params(is_active, params) when is_list(params), do: [{:is_active, is_active} | params]
  def params(is_active) when is_boolean(is_active), do: [is_active: is_active]
  def params(params), do: params
end
