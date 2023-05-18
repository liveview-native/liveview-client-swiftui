defmodule LiveViewNativeSwiftUi.Types.FillStyle do
  @derive Jason.Encoder
  defstruct [eo_fill: false, antialiased: true]

  use LiveViewNativePlatform.Modifier.Type
  def type, do: :map

  def cast(nil), do: {:ok, nil}
  def cast(value) when is_map(value) or is_list(value) do
    {:ok, struct(__MODULE__, value)}
  end

  def cast(_), do: :error
end
