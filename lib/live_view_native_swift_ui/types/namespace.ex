defmodule LiveViewNativeSwiftUi.Types.Namespace do
  @derive Jason.Encoder
  use LiveViewNativePlatform.Modifier.Type
  def type, do: :string

  def cast(value) when is_atom(value), do: {:ok, Atom.to_string(value)}
  def cast(_), do: :error
end
