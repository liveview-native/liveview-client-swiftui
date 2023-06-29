defmodule LiveViewNativeSwiftUi.Types.ModifierStack do
  use LiveViewNativePlatform.Modifier.Type
  def type, do: :map

  def cast(%LiveViewNativeSwiftUi.Modifiers{} = value), do: {:ok, Jason.decode!(Jason.encode!(value))}
  def cast(_), do: :error
end
