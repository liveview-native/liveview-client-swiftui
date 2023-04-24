defmodule LiveViewNativeSwiftUi.Modifiers.ContentTransition do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.ContentTransition

  modifier_schema "content_transition" do
    field :transition, ContentTransition
  end
end
