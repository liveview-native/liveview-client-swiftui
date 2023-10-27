defmodule MockSheet do
  use LiveViewNative.Stylesheet, :swiftui

  ~SHEET"""
  "color-red" do
    color(.red)
  end

  # this is a comment and isn't included in the output

  "button-" <> style do
    # this is also a comment that isn't included in the output
    buttonStyle(to_ime(style))
  end
  """

  def class(_other, _), do: {:unmatched, ""}
end
