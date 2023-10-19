defmodule LvnTutorialWeb.CatsListLive do
  use LvnTutorialWeb, :live_view
  use LiveViewNative.LiveView

  @cats [
    "Clenil",
    "Flippers",
    "Jorts",
    "Kipper",
    "Lemmy",
    "Lissy",
    "Mikkel",
    "Minka",
    "Misty",
    "Nelly",
    "Ninj",
    "Pollito",
    "Siegfried",
    "Truman",
    "Washy"
  ]

  def mount(_params, _session, socket) do
    {:ok, assign(socket, cats: @cats)}
  end

  def render(%{layout: :html} = assigns) do
    ~H""
  end

  def render(%{layout: :swiftui} = assigns) do
    ~SWIFTUI"""
    <Text>Hello, world!</Text>
    """
  end
end
