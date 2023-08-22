defmodule LiveViewNativeSwiftUi.Modifiers.ProjectionEffect do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.ProjectionTransform

  modifier_schema "projection_effect" do
    field :transform, ProjectionTransform
  end

  def params(params) do
    with {:ok, _} <- ProjectionTransform.cast(params) do
      [transform: params]
    else
      _ ->
        params
    end
  end
end
