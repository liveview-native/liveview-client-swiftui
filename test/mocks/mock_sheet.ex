defmodule MockSheet do
  use LiveViewNative.Stylesheet, :swiftui

  ~SHEET"""
  "color-red" do
    color(.red)
  end
  """

  def class(_other, _), do: {:unmatched, ""}
end
