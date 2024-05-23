defmodule LiveViewNative.SwiftUI.UtilityStyles do
  @moduledoc """
  Tailwind-style utility classes for LiveView Native.

  ## Modifier Translation
  Modifiers can easily be translated to classes.

  1. Separate any arguments with a dash (`-`)
  2. Use labels for any named arguments (`key:value`)

  | Modifier | Class |
  | -------- | ----- |
  | `padding(.leading, 32)` | `padding-leading-32` |
  | `frame(width: 100, height: 100)` | `frameWidth:100-height:100` |
  | `buttonStyle(.borderedProminent)` | `buttonStyle-borderedProminent` |

  ### Attribute References
  To reference an attribute value, use `[attr(attribute-name)]`:

  ```html
  <Group class="offset-y:[attr(offset)]" offset="5">
  ```

  ### Complex Arguments
  Complex types (such as a gradient `ShapeStyle`) can be provided by writing out the full syntax as an argument.

  ```html
  <Rectangle class="fg(LinearGradient(colors:[.red,.blue],startPoint:.leading,endPoint:.trailing))" />
  <Image class="font(.system(size:70))" />
  ```

  > [!NOTE]
  > Spaces cannot be used within class names.

  ### Spaces and Underscores
  To include a space in a string argument, use and underscore `['Hello,_world!']`.
  Any underscores will be replaced with a space.

  ```html
  <Group class="navigationTitle-['Hello_World']">
  ```

  If you need to include an underscore character, escape it with `\_`.

  ```html
  <Group class="navigationTitle-['Hello\_World']">
  ```

  ### Shorthand
  Some aliases are provided to make common classes easier to use.

  | Alias | Expansion |
  | ----- | --------- |
  | `px` | `padding-horizontal` |
  | `py` | `padding-vertical` |
  | `pt` | `padding-top` |
  | `pr` | `padding-trailing` |
  | `pb` | `padding-bottom` |
  | `pl` | `padding-leading` |
  | `pl` | `padding-leading` |
  | `p` | `padding` |
  | `w-` | `frame-width:` |
  | `h-` | `frame-height:` |
  | `min-w-` | `frame-minWidth:` |
  | `max-w-` | `frame-maxWidth:` |
  | `min-h-` | `frame-minHeight:` |
  | `max-h-` | `frame-maxHeight:` |
  | `fg` | `foregroundStyle` |
  | `bg` | `background` |
  | `overlay--` | `overlay-content::` |
  | `bg--` | `background-content::` |
  | `mask--` | `mask-mask::` |
  | `toolbar--` | `toolbar-content::` |
  | `safe-area-inset--` | `safeAreaInset-content::` |
  """

  @modifier_names_path "lib/live_view_native/swiftui/styles/modifier.names"
  @external_resource @modifier_names_path
  @modifier_names @modifier_names_path
  |> File.read!()
  |> String.split("\n", trim: true)

  @aliases %{
    "px" => "padding-horizontal",
    "py" => "padding-vertical",
    "pt" => "padding-top",
    "pr" => "padding-trailing",
    "pb" => "padding-bottom",
    "pl" => "padding-leading",
    "p" => "padding",
    "w-" => "frame-width:",
    "h-" => "frame-height:",
    "min-w-" => "frame-minWidth:",
    "max-w-" => "frame-maxWidth:",
    "min-h-" => "frame-minHeight:",
    "max-h-" => "frame-maxHeight:",
    "fg" => "foregroundStyle",
    "bg" => "background",
    "overlay--" => "overlay-content::",
    "bg--" => "background-content::",
    "mask--" => "mask-mask::",
    "toolbar--" => "toolbar-content::",
    "safe-area-inset--" => "safeAreaInset-content::",
  }

  defmacro sigil_RULES({:<<>>, _meta, [rules]}, _modifier) do
    opts = [
      file: __CALLER__.file,
      line: __CALLER__.line + 1,
      module: __CALLER__.module,
      variable_context: nil
    ]

    compiled_rules =
      rules
      |> String.replace("{", "<%=")
      |> String.replace("}", "%>")
      |> EEx.compile_string()

    quote do
      LiveViewNative.SwiftUI.RulesParser.parse(unquote(compiled_rules), unquote(opts))
    end
  end

  def parse(body, opts \\ []) do
    opts =
      opts
      |> Keyword.put_new(:variable_context, Elixir)
      |> Keyword.update(:file, "", &Path.basename/1)

    body
    |> String.replace("\r\n", "\n")
    |> LiveViewNative.SwiftUI.RulesParser.parse(opts)
  end

  for {key, value} <- Enum.sort_by(@aliases, fn {k, _} -> String.length(k) end, :desc) do
    def class(unquote(key)) do
      class(unquote(value))
    end
    if String.ends_with?(key, "-") do
      def class(unquote(key) <> arguments) do
        class(unquote(value) <> arguments)
      end
    else
      def class(unquote(key) <> "-" <> arguments) do
        class(unquote(value) <> "-" <> arguments)
      end
    end
  end

  for modifier <- Enum.uniq(@modifier_names) |> Enum.sort_by(&String.length/1, :desc) do
    def class(unquote(modifier) <> arguments = class_name) do
      name = unquote(modifier)

      try do
        arguments = LiveViewNative.SwiftUI.UtilityStyles.parse_arguments(arguments)
        ~RULES"""
        {name}({arguments})
        """
      rescue
        _ ->
          {:unmatched, "Stylesheet warning: Could not match on class: #{class_name}"}
      end
    end
  end

  def class(unmatched) do
    {:unmatched, "Stylesheet warning: Could not match on class: #{inspect(unmatched)}"}
  end

  def parse_arguments(<<?(, arguments::binary>>) do
    <<?), arguments::binary>> = String.reverse(arguments)

    arguments
    |> String.reverse()
    |> String.replace(":", ": ")
    |> String.replace(",", ", ")
    |> String.replace(~S('), ~S("))
  end

  def parse_arguments(arguments) do
    arguments
    |> String.trim_leading("-") # remove dash separating first argument
    |> String.split(~r/(?<!-|:)-/) # arguments separated by a dash
    |> Enum.map(fn arg ->
      if String.contains?(arg, ":") and not String.starts_with?(arg, ":") do
        [name | value] = String.split(arg, ":")
        value = Enum.join(value, ":")
        "#{name}: #{encode_argument(value)}" # add space between label and value
      else
        "#{encode_argument(arg)}" # encode argument values
      end
    end)
    |> Enum.join(", ") # rejoin arguments with commas instead of dashes
    |> String.replace(":.", ": .")
  end

  defp encode_argument(value) when value in ["true", "false"], do: value
  defp encode_argument(value) do
    case Regex.run(~r/^(\[)attr\(([^)]+)\)(\])$/, value) do # [attr(attribute)]
      [_, _, attr, _] ->
        "attr(\"#{attr}\")"
      _ ->
        case Regex.run(~r/^\['([^']*)'\]$/, value) do # ['string_value']
          [_, string] ->
            "\"#{Regex.replace(~r/(?<!\\)_/, string, " ")}\"" # replace `_` with space unless escaped
          _ ->
          if Regex.match?(~r/^[A-z]([A-z]|\d|_)*$/, value) do
            ".#{value}" # plain text arguments are treated as `.` members
          else
            value
          end
        end
    end
  end
end
