defmodule MockSheet do
  use LiveViewNative.Stylesheet, :swiftui

  ~SHEET"""
  "color-red" do
    color(.red)
    color(.blue)
  end
  """

  def class(_other, _), do: {:unmatched, ""}
end
