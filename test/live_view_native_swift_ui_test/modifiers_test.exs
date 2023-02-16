defmodule LiveViewNativeSwiftUiTest.ModifiersTest do
  use ExUnit.Case
  doctest LiveViewNativeSwiftUi.Modifiers

  test "escapes json quotes" do
    actual =
      %LiveViewNativeSwiftUi.Modifiers{padding: %{all: 100}}
      |> Phoenix.HTML.Safe.to_iodata()
      |> IO.iodata_to_binary()

    assert actual == "[{&quot;type&quot;:&quot;padding&quot;,&quot;all&quot;:100}]"
  end
end
