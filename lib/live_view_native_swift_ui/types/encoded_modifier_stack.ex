defmodule LiveViewNativeSwiftUi.Types.EncodedModifierStack do
  use LiveViewNativePlatform.Modifier.Type
  def type, do: :string

  def cast(value) when is_struct(value, LiveViewNativePlatform.Context) do
    {:ok, Jason.encode!(value.modifiers)}
  end
  def cast(_), do: :error
end
