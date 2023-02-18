defmodule LiveViewNativeSwiftUi.Types.Gradient.Stop do
  @derive Jason.Encoder
  defstruct [:color, :location]

  use LiveViewNativePlatform.Modifier.Type
  def type, do: :map

  alias LiveViewNativeSwiftUi.Types.Color

  def cast(value) when is_map(value) or is_list(value), do: cast({value[:color], value[:location]})

  def cast({color, location}) do
    case Color.cast(color) do
      {:ok, cast_color} ->
        {:ok, %__MODULE__{color: cast_color, location: location}}

      _ ->
        :error
    end
  end

  def cast(_), do: :error
end
