defmodule LiveViewNativeSwiftUi.Modifiers.ContainerShape do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.Shape

  modifier_schema "container_shape" do
    field :shape, Shape
  end

  def params(params) do
    with {:ok, _} <- Shape.cast(params) do
      [shape: params]
    else
      _ ->
        params
    end
  end
end
