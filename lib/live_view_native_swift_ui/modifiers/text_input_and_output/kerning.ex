defmodule LiveViewNativeSwiftUi.Modifiers.Kerning do
  use LiveViewNativePlatform.Modifier

  modifier_schema "kerning" do
    field(:kerning, :float)
  end

  def params(kerning) when is_number(kerning), do: [kerning: kerning]
  def params(params), do: params
end
