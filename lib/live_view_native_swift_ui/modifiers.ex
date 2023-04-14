defmodule LiveViewNativeSwiftUi.Modifiers do
  use LiveViewNativePlatform.Modifiers

  defimpl Phoenix.HTML.Safe do
    def to_iodata(%{stack: stack}) do
      modifiers =
        Enum.reduce(stack, [], fn %modifier_schema{} = modifier, acc ->
          key = apply(modifier_schema, :modifier_name, [])
          props = apply(modifier_schema, :to_map, [modifier])

          case props do
            %{} = props ->
              modifier =
                props
                |> Enum.into(%{})
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
          |> Phoenix.HTML.Engine.html_escape()
      end
    end
  end
end
