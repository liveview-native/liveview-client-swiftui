defmodule LiveViewNative.SwiftUI.RulesParser.Parser.Annotations do
  alias LiveViewNative.SwiftUI.RulesParser.Parser.Context
  # Helpers

  def context_to_annotation(%Context{annotations: true} = context, line) do
    [file: context.file, line: line, module: context.module]
  end

  def context_to_annotation(_, _) do
    []
  end
end
