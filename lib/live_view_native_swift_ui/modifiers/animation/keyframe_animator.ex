defmodule LiveViewNativeSwiftUi.Modifiers.KeyframeAnimator do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.EncodedModifierStack
  alias LiveViewNativeSwiftUi.Types.Keyframe
  alias LiveViewNativeSwiftUi.Types.KeyName

  modifier_schema "keyframe_animator" do
    field :initial_value, :float
    field :trigger, :string
    field :keyframes, {:array, Keyframe}
    field :modifiers, EncodedModifierStack
    field :properties, {:array, KeyName}
  end
end
