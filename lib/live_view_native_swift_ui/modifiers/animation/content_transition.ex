defmodule LiveViewNativeSwiftUi.Modifiers.ContentTransition do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.ContentTransition

  modifier_schema "content_transition" do
    field :transition, ContentTransition
  end

  def params(params) do
    with {:ok, _} <- ContentTransition.cast(params) do
      [transition: params]
    else
      _ ->
        params
    end
  end
end
