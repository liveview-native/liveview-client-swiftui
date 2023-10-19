defmodule LiveViewNative.SwiftUI.RulesHelpers do
  use LiveViewNative.Stylesheet.RulesParser.Helpers, additional: []

  def to_ime(expr) when is_binary(expr) do
    {:., [], [nil, String.to_atom(expr)]}
  end

  def event(name, opts \\ []) do
    {:__event__, [], [name, opts]}
  end
end
