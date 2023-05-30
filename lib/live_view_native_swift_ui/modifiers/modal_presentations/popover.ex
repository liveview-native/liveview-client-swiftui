defmodule LiveViewNativeSwiftUi.Modifiers.Popover do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.{NativeBindingName, PopoverAttachmentAnchor, Edge, KeyName}

  modifier_schema "popover" do
    field :is_presented, NativeBindingName
    field :attachment_anchor, PopoverAttachmentAnchor
    field :arrow_edge, Edge
    field :content, KeyName
  end
end
