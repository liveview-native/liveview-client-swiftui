defmodule LiveViewNativeSwiftUi.Modifiers.Animation do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.Animation

  modifier_schema "animation" do
    field :animation, Animation
    field :value, :string
  end
end
