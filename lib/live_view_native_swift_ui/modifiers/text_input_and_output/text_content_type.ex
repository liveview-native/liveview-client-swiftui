defmodule LiveViewNativeSwiftUi.Modifiers.TextContentType do
  use LiveViewNativePlatform.Modifier

  modifier_schema "text_content_type" do
    field(:text_content_type, Ecto.Enum, values: ~w(
      url
      name_prefix
      name
      name_suffix
      given_name
      middle_name
      family_name
      nickname
      organization_name
      job_title
      location
      full_street_address
      street_address_line_1
      street_address_line_2
      address_city
      address_city_and_state
      address_state
      postal_code
      sublocality
      country_name
      username
      password
      new_password
      one_time_code
      email_address
      telephone_number
      credit_card_number
      date_time
      flight_number
      shipment_tracking_number
    )a)
  end

  def params(text_content_type) when is_atom(text_content_type) and not is_boolean(text_content_type) and not is_nil(text_content_type), do: [text_content_type: text_content_type]
  def params(params), do: params
end
