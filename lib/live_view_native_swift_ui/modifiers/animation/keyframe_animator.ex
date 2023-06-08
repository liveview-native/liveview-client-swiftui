defmodule LiveViewNativeSwiftUi.Modifiers.KeyframeAnimator do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.{EncodedModifierStack, Keyframe, KeyframeProperties}

  modifier_schema "keyframe_animator" do
    field :initial_value, :float
    field :trigger, :string
    field :keyframes, {:array, Keyframe}
    field :modifiers, EncodedModifierStack
    field :properties, KeyframeProperties
  end
end
