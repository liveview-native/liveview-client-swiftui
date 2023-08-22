defmodule LiveViewNativeSwiftUi.Modifiers.Badge do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.KeyName

  modifier_schema "badge" do
    field :content, KeyName
    field :label, :string
    field :count, :integer
  end

  def params(label) when is_binary(label), do: [label: label]
  def params(count) when is_number(count), do: [count: count]
  def params(params) do
    with {:ok, _} <- KeyName.cast(params) do
      [content: params]
    else
      _ ->
        params
    end
  end
end
