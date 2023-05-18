defmodule LiveViewNativeSwiftUi.Modifiers.KeyboardShortcut do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.EventModifier

  modifier_schema "keyboard_shortcut" do
    field :key, Ecto.Enum, values: ~w(
      up_arrow
      down_arrow
      left_arrow
      right_arrow
      clear
      delete
      end
      escap
      home
      page_up
      page_down
      return
      space
      tab
      a b c d e f g i j k l m n o p q r s t u v w x y
      A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
      0 1 2 3 4 5 6 7 8 9
      ! @ # $ % ^ & * ( \) _ + = _ [ ] { } | ; : ' " < > , . / ?
      )a
    field :event_modifiers, EventModifier
  end
end
