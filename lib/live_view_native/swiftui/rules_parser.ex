defmodule LiveViewNative.SwiftUI.RulesParser do
  use LiveViewNative.Stylesheet.RulesParser, :mock

  def __using__(_) do
    quote do
      import LiveViewNative.SwiftUI.RulesParser, only: [sigil_RULES: 2]
      import LiveViewNative.SwiftUI.RulesHelpers
    end
  end

  def parse(rules) do
    rules
  end
end
