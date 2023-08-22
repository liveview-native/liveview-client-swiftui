defmodule LiveViewNativePlatform.Modifier.Types.EventModifier do
  use LiveViewNativePlatform.Modifier.Type
  def type, do: {:array, :string}

  def cast(value) when is_atom(value), do: {:ok, [Atom.to_string(value)]}
  def cast(value) when is_list(value), do: {:ok, Enum.map(value, &Atom.to_string/1)}
  def cast(_), do: :error
end
