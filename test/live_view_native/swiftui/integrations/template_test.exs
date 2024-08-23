defmodule LiveViewNative.SwiftUI.TemplateRenderTest do
  use ExUnit.Case, async: false

  import Phoenix.ConnTest
  import Phoenix.LiveViewTest
  import LiveViewNativeTest

  @endpoint LiveViewNativeTest.Endpoint

  setup do
    {:ok, conn: Plug.Test.init_test_session(build_conn(), %{})}
  end

  test "can render the override swiftui format", %{conn: conn} do
    {:ok, lv, _body} = native(conn, "/template", :swiftui)

    assert lv |> element("text") |> render() =~ "Template SwiftUI Render 100"
  end

  test "can render the override swiftui format with watchos target", %{conn: conn} do
    {:ok, lv, _body} = native(conn, "/template", :swiftui, %{"target" => "watchos"})

    assert lv |> element("text") |> render() =~ "WatchOS Target Template SwiftUI Render 100"
  end
end
