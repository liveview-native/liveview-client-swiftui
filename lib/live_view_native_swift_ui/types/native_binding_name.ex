defmodule LiveViewNativeSwiftUi.Types.NativeBindingName do
  use LiveViewNativePlatform.Modifier.Type
  def type, do: :map

  def cast(%{ value: _, change: _ } = change_tracked_value), do: {:ok, change_tracked_value}
  def cast(_), do: :error
end
