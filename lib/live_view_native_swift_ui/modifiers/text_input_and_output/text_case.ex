defmodule LiveViewNativeSwiftUi.Modifiers.TextCase do
  use LiveViewNativePlatform.Modifier

  modifier_schema "text_case" do
    field :text_case, Ecto.Enum, values: ~w(lowercase uppercase)a
  end
end
