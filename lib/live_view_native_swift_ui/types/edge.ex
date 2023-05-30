defmodule LiveViewNativeSwiftUi.Types.Edge do
  use LiveViewNativePlatform.Modifier.Type
  def type, do: :string

  @values ~w(leading trailing top bottom)a

  def cast(value) when value in @values, do: {:ok, Atom.to_string(value)}
  def cast(_), do: :error
end
