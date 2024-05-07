defmodule <%= inspect context.web_module %>.Styles.<%= inspect context.schema_module %>.<%= inspect context.module_suffix %> do
  use LiveViewNative.Stylesheet, <%= inspect context.format %>
  # Read more about UtilityStyles if you want to use them
  @import LiveViewNative.SwiftUI.UtilityStyles

  # Add your styles here
  # Refer to your client's documentation on what the proper syntax
  # is for defining rules within classes
  ~SHEET"""
  """

  # If you need to have greater control over how your style rules are created
  # you can use the function defintion style which is more verbose but allows
  # for more fine-grained controled
  #
  # This example shows what is not possible within the more concise ~SHEET
  # use `<Text class="frame:w100:h200" />` allows for a setting
  # of both the `width` and `height` values.

  # def class("frame:" <> dims) do
  #   [width] = Regex.run(~r/w(\d+)/, dims, capture: :all_but_first)
  #   [height] = Regex.run(~r/h(\d+)/, dims, capture: :all_but_first)

  #   ~RULES"""
  #   frame(width: {width}, height: {height})
  #   """
  # end
end
