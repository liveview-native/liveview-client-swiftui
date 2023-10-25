defmodule MockSheet do
  use LiveViewNative.Stylesheet, :swiftui

  ~SHEET"""
  "color-red" do
    color(.red)
  end

  "button-" <> style do
    buttonStyle(to_ime(style))
  end
  """

  def class(_other, _), do: {:unmatched, ""}
end
