defmodule LiveViewNativeSwiftUi.Types.KeyName do
  use LiveViewNativePlatform.Modifier.Type
  def type, do: :string

  def cast(value) when is_atom(value) and not is_nil(value) and not is_boolean(value), do: {:ok, Atom.to_string(value)}
  def cast(_), do: :error
end
