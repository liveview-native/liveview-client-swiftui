defmodule LiveViewNativeSwiftUi.Modifiers.Transition do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.Transition

  modifier_schema "transition" do
    field :transition, Transition
  end

  def params(params) do
    with {:ok, _} <- Transition.cast(params) do
      [transition: params]
    else
      _ ->
        params
    end
  end
end
