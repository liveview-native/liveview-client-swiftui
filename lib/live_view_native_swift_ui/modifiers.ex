defmodule LiveViewNativeSwiftUi.Modifiers do
  @moduledoc false
  defstruct stack: []

  def encode_map(%{} = map) do
    Enum.into(map, %{})
  end

  defimpl LiveViewNativePlatform.Modifiers do
    def append(%{stack: stack} = modifiers, modifier) do
      stack = stack || []

      %{modifiers | stack: stack ++ [modifier]}
    end
  end

  defimpl Phoenix.HTML.Safe do
    alias LiveViewNativeSwiftUi.Modifiers

    def to_iodata(%{stack: stack}) do
      modifiers =
        Enum.reduce(stack, [], fn %modifier_schema{} = modifier, acc ->
          key = apply(modifier_schema, :modifier_name, [])
          props = apply(modifier_schema, :to_map, [modifier])

          case props do
            %{} = props ->
              modifier =
                props
                |> Modifiers.encode_map()
                |> Map.put(:type, key)

              acc ++ [modifier]

            _ ->
              acc
          end
        end)

      case modifiers do
        [] ->
          ""

        modifiers ->
          Jason.encode!(modifiers)
          |> IO.inspect()
          |> Phoenix.HTML.Engine.html_escape()
      end
    end
  end
end
