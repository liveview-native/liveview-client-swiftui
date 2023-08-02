defmodule LiveViewNativeSwiftUi.Types.EncodedModifierStack do
  use LiveViewNativePlatform.Modifier.Type
  def type, do: :string

  def cast(%LiveViewNativeSwiftUi.Modifiers{} = modifiers) do
    {:ok, Jason.encode!(modifiers)}
  end
  def cast(_), do: :error
end
