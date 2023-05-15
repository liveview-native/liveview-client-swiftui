defmodule LiveViewNativeSwiftUi.Modifiers.KeyboardType do
  use LiveViewNativePlatform.Modifier

  modifier_schema "keyboard_type" do
    field :keyboard_type, Ecto.Enum, values: ~w(
      default
      ascii_capable
      numbers_and_punctuation
      url
      number_pad
      name_phone_pad
      email_address
      decimal_pad
      twitter
      web_search
      ascii_capable_number_pad
    )a
  end
end
