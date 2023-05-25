defmodule LiveViewNativeSwiftUi.Types.KeyEquivalent do
  use LiveViewNativePlatform.Modifier.Type
  def type, do: :string

  @keys [
    :up_arrow,
    :down_arrow,
    :left_arrow,
    :right_arrow,
    :clear,
    :delete,
    :end,
    :escape,
    :home,
    :page_up,
    :page_down,
    :return,
    :space,
    :tab
  ]

  def cast(value) when is_atom(value) and value in @keys, do: {:ok, Atom.to_string(value)}
  def cast(value) when is_binary(value) and byte_size(value) == 1, do: {:ok, value}
  def cast(value) when is_list(value) and length(value) == 1, do: {:ok, to_string(value)}
  def cast(_), do: :error
end
