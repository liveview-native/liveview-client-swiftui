defmodule LiveViewNativeSwiftUi.Modifiers.SafeAreaInset do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.KeyName

  modifier_schema "safe_area_inset" do
    field :edge, Ecto.Enum, values: ~w(leading trailing top bottom)a
    field :alignment, Ecto.Enum, values: ~w(leading trailing top bottom center)a, default: :center
    field :spacing, :float
    field :content, KeyName
  end
end
