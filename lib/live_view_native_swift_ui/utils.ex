defmodule LiveViewNativeSwiftUi.Utils do
  def encode_key(key) when is_atom(key), do: encode_key("#{key}")

  def encode_key(key) when is_binary(key) do
    key
    |> String.downcase()
    |> String.replace("_" , "-")
  end
end
