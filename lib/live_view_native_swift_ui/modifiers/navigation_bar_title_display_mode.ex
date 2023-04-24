defmodule LiveViewNativeSwiftUi.Modifiers.NavigationBarTitleDisplayMode do
  use LiveViewNativePlatform.Modifier

  modifier_schema "navigation_bar_title_display_mode" do
    field(:display_mode, Ecto.Enum, values: ~w(
      automatic
      inline
      large
    )a)
  end
end
