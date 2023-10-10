defmodule LiveViewNative.SwiftUI.RulesHelpers do
  def to_ime(expr) when is_binary(expr) do
    {:., [], [nil, String.to_atom(expr)]}
  end
end
