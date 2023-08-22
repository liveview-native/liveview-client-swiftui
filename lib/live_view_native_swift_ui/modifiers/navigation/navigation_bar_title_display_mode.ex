defmodule LiveViewNativeSwiftUi.Modifiers.NavigationBarTitleDisplayMode do
  use LiveViewNativePlatform.Modifier

  modifier_schema "navigation_bar_title_display_mode" do
    field(:display_mode, Ecto.Enum, values: ~w(
      automatic
      inline
      large
    )a)
  end

  def params(display_mode) when is_atom(display_mode) and not is_boolean(display_mode) and not is_nil(display_mode), do: [display_mode: display_mode]
  def params(params), do: params
end
