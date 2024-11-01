File.read!("priv/templates/lvn.swiftui.gen/core_components.ex")
|> EEx.eval_string([
  context: %{
    web_module: LiveViewNativeTest,
    module_suffix: SwiftUI
  },
  assigns: %{
    live_form?: true,
    gettext: true,
    version: Application.spec(:live_view_native_swiftui)[:vsn]
  }
])
|> Code.eval_string()
|> IO.inspect()
