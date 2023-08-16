defmodule LiveViewNativeSwiftUi.Modifiers.Popover do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.{PopoverAttachmentAnchor, Edge, KeyName}

  modifier_schema "popover" do
    field :is_presented, :boolean
    field :attachment_anchor, PopoverAttachmentAnchor
    field :arrow_edge, Edge
    field :content, KeyName

    change_event()
  end
end
