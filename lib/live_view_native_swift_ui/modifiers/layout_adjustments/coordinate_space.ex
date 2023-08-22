defmodule LiveViewNativeSwiftUi.Modifiers.CoordinateSpace do
  use LiveViewNativePlatform.Modifier

  modifier_schema "coordinate_space" do
    field :name, :string
  end

  def params(name) when is_binary(name), do: [name: name]
  def params(params), do: params
end
