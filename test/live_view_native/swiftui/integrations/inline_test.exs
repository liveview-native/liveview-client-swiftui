defmodule LiveViewNative.SwiftUI.InlineRenderTest do
  use ExUnit.Case, async: false

  import Phoenix.ConnTest
  require Phoenix.LiveViewTest
  import LiveViewNativeTest

  @endpoint LiveViewNativeTest.Endpoint

  setup do
    {:ok, conn: Plug.Test.init_test_session(build_conn(), %{})}
  end

  test "can render the override html format", %{conn: conn} do
    {:ok, lv, _body} = live(conn, "/inline", _format: :swiftui)

    assert lv |> element("Text") |> render() =~ "Inline SwiftUI Render 100"
  end

  test "can render the swiftui format with watchos target", %{conn: conn} do
    {:ok, lv, _body} = live(conn, "/inline", _format: :swiftui, _interface: %{"target" => "watchos"})

    assert lv |> element("Text") |> render() =~ "WatchOS Target Inline SwiftUI Render 100"
  end
end
