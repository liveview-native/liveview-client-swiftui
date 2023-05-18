defmodule LiveViewNativeSwiftUi.Modifiers.TransformEffect do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.AffineTransform

  modifier_schema "transform_effect" do
    field :transform, AffineTransform
  end
end
