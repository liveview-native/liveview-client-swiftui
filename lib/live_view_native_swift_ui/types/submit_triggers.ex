defmodule LiveViewNativeSwiftUi.Types.SubmitTriggers do
  use LiveViewNativePlatform.Modifier.Type
  def type, do: {:array, :string}

  def cast(trigger) when is_atom(trigger), do: {:ok, [Atom.to_string(trigger)]}
  def cast(triggers) when is_list(triggers), do: {:ok, Enum.map(triggers, &Atom.to_string/1)}
  def cast(_), do: :error
end
