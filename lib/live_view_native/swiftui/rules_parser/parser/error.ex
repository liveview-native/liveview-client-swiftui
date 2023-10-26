defmodule LiveViewNative.SwiftUI.RulesParser.Parser.Error do
  alias LiveViewNative.SwiftUI.RulesParser.Parser.Context

  defstruct([
    :incorrect_text,
    :show_incorrect_text?,
    :line,
    :byte_offset,
    :error_message,
    forced?: false
  ])

  def put_error(
        rest,
        args,
        context,
        _,
        _,
        error_message,
        opts \\ []
      )

  def put_error(
        rest,
        [] = arg,
        context,
        {line, _offset},
        byte_offset,
        error_message,
        opts
      ) do
    # IO.inspect({[], rest, error_message}, label: "error[0]")

    context =
      Context.put_new_error(context, rest, %__MODULE__{
        incorrect_text: "",
        line: line,
        byte_offset: byte_offset,
        error_message: error_message,
        show_incorrect_text?: Keyword.get(opts, :show_incorrect_text?, false),
        forced?: Keyword.get(opts, :force_error?, false)
      })

    {rest, arg, context}
  end

  def put_error(
        rest,
        [matched_text | _] = args,
        context,
        {line, _offset},
        byte_offset,
        error_message,
        opts
      ) do
    # IO.inspect({matched_text, rest, error_message}, label: "error[0]")

    context =
      Context.put_new_error(context, rest, %__MODULE__{
        incorrect_text: matched_text,
        line: line,
        byte_offset: byte_offset,
        error_message: error_message,
        show_incorrect_text?: Keyword.get(opts, :show_incorrect_text?, false),
        forced?: Keyword.get(opts, :force_error?, false)
      })

    {rest, args, context}
  end

  def context_to_error_message(context) do
    [%__MODULE__{} = error | _] = Enum.reverse(context.errors)

    error_message = error.error_message
    line = error.line
    incorrect_text = error.incorrect_text
    byte_offset = error.byte_offset

    source_line = (context.source_line || 1) + line - 1

    error_text_length = String.length(incorrect_text)

    before = String.slice(context.source, 0, max(0, byte_offset - error_text_length))
    middle = String.slice(context.source, byte_offset - error_text_length, error_text_length)
    middle = if(middle == " ", do: "_", else: middle)
    # middle = if(middle == "", do: "▮", else: middle)
    after_ = String.slice(context.source, byte_offset..-1//1)

    source_lines =
      [
        before,
        IO.ANSI.format([:red, middle]),
        case {after_, middle} do
          {"", ""} ->
            IO.ANSI.format([:red, "_"])

          _ ->
            after_
        end
      ]
      |> IO.iodata_to_binary()
      |> String.split("\n")
      |> Enum.at(line - 1)
      |> List.wrap()

    error_lines =
      [
        String.replace(before, ~r/([^\n])/, " "),
        IO.ANSI.format([:red, String.replace(middle, ~r/[^\n]/, "^")]),
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

    message = """
    Unsupported input:
    #{line_spacer} |
    #{lines}
    #{line_spacer} |

    #{error_message}#{maybe_but_got}
    """

    {message, {source_line, 0}, error.byte_offset}
  end
end
