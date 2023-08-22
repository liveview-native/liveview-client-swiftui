defmodule LiveViewNativeSwiftUi.Modifiers.SearchCompletion do
  use LiveViewNativePlatform.Modifier

  modifier_schema "search_completion" do
    field :completion, :string
    field :token, :string
  end

  def params(token) when is_atom(token) and not is_boolean(token) and not is_nil(token), do: [token: token]
  def params(completion) when is_binary(completion), do: [completion: completion]
  def params(params), do: params
end
