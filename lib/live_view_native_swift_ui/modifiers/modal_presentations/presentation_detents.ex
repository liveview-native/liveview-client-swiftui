defmodule LiveViewNativeSwiftUi.Modifiers.PresentationDetents do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.{PresentationDetent}

  modifier_schema "presentation_detents" do
    field :detents, {:array, PresentationDetent}
    field :selection, :integer, default: nil

    change_event()
  end

  def params(detents, [selection: selection]), do: [detents: detents, selection: selection]
  def params([detent | _] = params) do
    with {:ok, _} <- PresentationDetent.cast(detent) do
      [detents: params]
    else
      _ ->
        params
    end
  end
  def params(params), do: params
end
