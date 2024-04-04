{:ok, _} = LiveViewNativeTest.Endpoint.start_link()

[MockSheet, AppSheet]
|> Enum.each(&(LiveViewNative.Stylesheet.__after_verify__(&1)))

ExUnit.after_suite(fn(_) ->
  path = Application.get_env(:live_view_native_stylesheet, :output)
  File.rm_rf!(path)
end)

ExUnit.start()
