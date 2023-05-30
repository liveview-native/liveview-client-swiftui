defmodule LiveViewNativeSwiftUi.Modifiers.ProjectionEffect do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.ProjectionTransform

  modifier_schema "projection_effect" do
    field :transform, ProjectionTransform
  end
end
