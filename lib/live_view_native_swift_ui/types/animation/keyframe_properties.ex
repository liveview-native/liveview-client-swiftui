defmodule LiveViewNativeSwiftUi.Types.KeyframeProperties do
  use LiveViewNativePlatform.Modifier.Type
  def type, do: :map

  def cast(value) when is_list(value) or is_map(value) do
    {:ok, Enum.into(value, %{})}
  end

  def cast(_), do: :error
end
