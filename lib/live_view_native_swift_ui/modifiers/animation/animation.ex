defmodule LiveViewNativeSwiftUi.Modifiers.Animation do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.Animation

  modifier_schema "animation" do
    field :animation, Animation
    field :value, :string
  end

  def params(animation, [value: value]), do: [animation: animation, value: value]
  def params(params), do: params
end
