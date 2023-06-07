defmodule LiveViewNativeSwiftUi.Modifiers do
  use LiveViewNativePlatform.Modifiers

  defimpl Jason.Encoder do
    def encode(%{stack: stack}, opts) do
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
          nil

        modifiers ->
          Jason.Encode.list(modifiers, opts)
      end
    end
  end

  defimpl Phoenix.HTML.Safe do
    def to_iodata(struct) do
      Jason.encode!(struct)
        |> Phoenix.HTML.Engine.html_escape()
    end
  end
end
