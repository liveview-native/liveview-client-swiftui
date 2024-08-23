defmodule Mix.Tasks.Lvn.Swiftui.Setup.Gen do
  use Mix.Task

  alias Mix.LiveViewNative.Context

  @shortdoc "Setup Generators for LiveView Native SwiftUI within a project"

  @moduledoc """
  #{@shortdoc}

  This setup will configure your app and generate stylesheets for each available client

      $ mix lvn.swiftui.setup.gen

  """

  @impl true
  @doc false
  def run(args) do
    if Mix.Project.umbrella?() do
      Mix.raise(
        "mix lvn.stylesheet.setup must be invoked from within your *_web application root directory"
      )
    end

    args
    |> Context.build(__MODULE__)
    |> run_generators()
  end

  @doc false
  def run_generators(context) do
    generators(context)
    |> Enum.each(fn({task, args}) -> Mix.Task.run(task, args) end)

    context
  end

  @doc false
  def generators(_context) do
    [{"lvn.swiftui.gen", []}]
  end

  @doc false
  def switches, do: [
    context_app: :string,
    web: :string
  ]

  @doc false
  def validate_args!([]), do: [nil]
  def validate_args!(_args) do
    Mix.raise("""
    mix lvn.swiftui.setup.gen does not take any arguments, only the following switches:

    --context-app
    --web
    """)
  end
end
