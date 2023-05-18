defmodule LiveViewNativeSwiftUi.Types.StrokeStyle do
  @derive Jason.Encoder
  defstruct [
    line_width: 1,
    line_cap: :butt,
    line_join: :miter,
    miter_limit: 10,
    dash: [],
    dash_phase: 0
  ]

  use LiveViewNativePlatform.Modifier.Type
  def type, do: :map

  def cast(nil), do: {:ok, nil}
  def cast(value) when is_map(value) or is_list(value) do
    {:ok, struct(__MODULE__, value)}
  end

  def cast(_), do: :error
end
