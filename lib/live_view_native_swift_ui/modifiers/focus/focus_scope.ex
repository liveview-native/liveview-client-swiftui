defmodule LiveViewNativeSwiftUi.Modifiers.FocusScope do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.Namespace

  modifier_schema "focus_scope" do
    field :namespace, Namespace
  end

  def params(params) do
    with {:ok, _} <- Namespace.cast(params) do
      [namespace: params]
    else
      _ ->
        params
    end
  end
end
