defmodule LiveViewNative.SwiftUI do
  @moduledoc false

  use LiveViewNative,
    format: :swiftui,
    component: LiveViewNative.SwiftUI.Component,
    module_suffix: :SwiftUI,
    template_engine: LiveViewNative.Template.Engine,
    stylesheet_rules_parser: LiveViewNative.SwiftUI.RulesParser,
    test_client: %LiveViewNativeTest.SwiftUI.TestClient{}

  def normalize_os_version(os_version),
    do: normalize_version(os_version)

  def normalize_app_version(app_version),
    do: normalize_version(app_version)

  defp normalize_version(version) do
    version
    |> String.split(".")
    |> Enum.map(fn(number) ->
      {number, _rem} = Integer.parse(number)
      number
    end)
  end
end
