defmodule LiveViewNative.SwiftUI.RulesParser.Parser.Error do
  @moduledoc false

  alias LiveViewNative.SwiftUI.RulesParser.Parser.Context

  defstruct([
    :incorrect_text,
    :show_incorrect_text?,
    :line,
    :byte_offset,
    :error_message,
    forced?: false,
    is_warning?: false
  ])

  def put_error(
        rest,
        args,
        context,
        {line, _offset},
        byte_offset,
        error_message,
        opts \\ []
      ) do
    # IO.inspect({args, rest, error_message}, label: "error[0]")

    error = %__MODULE__{
      incorrect_text: List.first(args, ""),
      line: line,
      byte_offset: byte_offset,
      error_message: error_message,
      show_incorrect_text?: Keyword.get(opts, :show_incorrect_text?, false),
      forced?: Keyword.get(opts, :force_error?, false),
      is_warning?: false
    }

    context =
      case opts[:warning] do
        true ->
          # Always treat error as warning
          Context.put_new_error(context, rest, %{error | is_warning?: true})

        false ->
          # Never treat error as warning
          Context.put_new_error(context, rest, error)

        nil ->
          # Never treat error as warning
          Context.put_new_error(context, rest, error)

        warning ->
          # The error is an optional warning
          # Only log the warning if value in `context[<key>]` is true
          if get_in(context, [Access.key(warning)]) == true do
            Context.put_new_error(context, rest, %{error | is_warning?: true})
          else
            context
          end
      end

    {rest, args, context}
  end

  def context_to_error_message(context) do
    [%__MODULE__{} = error | _] = Enum.reverse(context.errors)
    context_to_error_message(context, error)
  end

  def context_to_error_message(context, %__MODULE__{} = error) do
    error_message = error.error_message
    line = error.line
    incorrect_text = error.incorrect_text
    byte_offset = error.byte_offset

    source_line = (context.source_line || 1) + line - 1

    error_text_length = String.length(incorrect_text)

    before = String.slice(context.source, 0, max(0, byte_offset - error_text_length))
    middle = String.slice(context.source, byte_offset - error_text_length, error_text_length)
    invisible_char = "‎"

    middle = if(middle == "", do: invisible_char, else: middle)
    after_ = String.slice(context.source, byte_offset..-1//1)

    source_lines =
      [
        before,
        if middle == invisible_char do
          IO.ANSI.format([:red_background, middle])
        else
          IO.ANSI.format([:red, middle])
        end,
        after_
      ]
      |> IO.iodata_to_binary()
      |> String.split("\n")
      |> Enum.at(line - 1)
      |> List.wrap()

    error_lines =
      [
        String.replace(before, ~r/([^\n])/, " "),
        middle
        |> String.replace(invisible_char, "^")
        |> String.replace(~r/[^\n]/, "^")
        |> then(&IO.ANSI.format([:red, &1])),
        String.replace(after_, ~r/([^\n])/, " ")
      ]
      |> IO.iodata_to_binary()
      |> String.split("\n")
      |> Enum.at(line - 1)
      |> List.wrap()

    max_line_number = "#{source_line + Enum.count(error_lines) - 1}"
    line_spacer = String.duplicate(" ", String.length(max_line_number))

    lines =
      Enum.zip(source_lines, error_lines)
      |> Enum.with_index(source_line)
      |> Enum.map(fn {{s_l, e_l}, line_num} ->
        """
        #{line_num} | #{s_l}
        #{line_spacer} | #{e_l}
        """
        |> String.trim()
      end)
      |> Enum.join("\n")

    maybe_but_got =
      if error.show_incorrect_text? do
        if String.ends_with?(error_message, "\n") do
          "\nbut got ‘#{incorrect_text}’"
        else
          ", but got ‘#{incorrect_text}’"
        end
      else
        ""
      end

    header =
      if error.is_warning? do
        "#{error_message}#{maybe_but_got}"
      else
        "Unsupported input:"
      end

    footer =
      if error.is_warning? do
        ""
      else
        """

        #{error_message}#{maybe_but_got}
        """
      end

    message = """
    #{header}
    #{line_spacer} |
    #{lines}
    #{line_spacer} |
    #{footer}
    """

    {message, {source_line, 0}, error.byte_offset}
  end
end
