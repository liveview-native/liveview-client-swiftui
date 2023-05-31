defmodule LiveViewNativeSwiftUi.Modifiers.ContainerShape do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.Shape

  modifier_schema "container_shape" do
    field :shape, Shape
  end
end
