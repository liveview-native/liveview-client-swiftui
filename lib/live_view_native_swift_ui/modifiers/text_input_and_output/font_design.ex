defmodule LiveViewNativeSwiftUi.Modifiers.FontDesign do
  use LiveViewNativePlatform.Modifier

  modifier_schema "font_design" do
    field :design, Ecto.Enum, values: ~w(
      default
      monospaced
      rounded
      serif
    )a
  end
end
