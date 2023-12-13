defmodule LiveViewNative.SwiftUI.RulesParser.Parser.Context do
  defstruct [
    :file,
    :annotations,
    :module,
    source: "",
    source_lines: [],
    errors: [],
    highlight_error: true,
    # Where in the code does the input start?
    # Useful for localizing errors when parsing sigil text
    source_line: 1,
    # When freezes is greater than 0, do not accept errors
    freezes: 0
  ]

  def prepare_context(rest, args, context, {_line, _offset}, _byte_binary_offset) do
    {rest, args,
     context
     |> Map.put_new(:context, %__MODULE__{
       source: rest,
       source_lines: String.split(rest, "\n"),
       file: context[:file] || "",
       module: context[:module] || nil,
       source_line: context[:source_line] || 1,
       highlight_error: Map.get(context, :highlight_error, true),
       annotations: Map.get(context, :annotations, true)
     })
     |> Map.drop([
       :file,
       :module,
       :source_line,
       :highlight_error
     ])}
  end

  def is_frozen?(%__MODULE__{freezes: freezes}), do: freezes > 0
  def is_frozen?(%{context: %__MODULE__{freezes: freezes}}), do: freezes > 0
  def has_error?(%__MODULE__{errors: errors}), do: errors != []
  def has_error?(%{context: %__MODULE__{errors: errors}}), do: errors != []

  def put_new_error(context, _rest, error) do
    if is_frozen?(context) and not error.forced? do
      context
    else
      path = [:context, Access.key(:errors)]

      {_, context} =
        get_and_update_in(context, path, fn
          existing_errors -> {[error | existing_errors], [error | existing_errors]}
        end)

      context
    end
  end

  def freeze_context(rest, args, context, {_line, _offset}, _byte_binary_offset) do
    {_, context} = get_and_update_in(context, [:context, Access.key(:freezes)], &{&1, &1 + 1})
    {rest, args, context}
  end

  def unfreeze_context(rest, args, context, {_line, _offset}, _byte_binary_offset) do
    {_, context} =
      get_and_update_in(context, [:context, Access.key(:freezes)], &{&1, max(0, &1 - 1)})

    {rest, args, context}
  end
end
