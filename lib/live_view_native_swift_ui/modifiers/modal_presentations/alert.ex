defmodule LiveViewNativeSwiftUi.Modifiers.Alert do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.{KeyName}

  modifier_schema "alert" do
    field(:title, :string)
    field(:actions, KeyName)
    field(:message, KeyName, default: nil)
    field(:is_presented, :boolean)

    change_event()
  end

  def params(title, params) when is_binary(title) and is_list(params), do: [{:title, title} | params]
  def params(params), do: params
end
