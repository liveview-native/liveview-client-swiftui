defmodule LiveViewNative.SwiftUI.UtilityStyles do
  use LiveViewNative.Stylesheet, :swiftui
  @export true

  @moduledoc """
  Tailwind-style utility classes for LiveView Native.

  ## Modifier Translation
  Modifiers can easily be translated to classes.

  1. Write the name of the modifier in `snake-case`
  2. Separate any arguments with a dash (`-`)
  3. Use labels for any named arguments (`key:value`)

  | Modifier | Class |
  | -------- | ----- |
  | `padding(.leading, 32)` | `padding-leading-32` |
  | `frame(width: 100, height: 100)` | `frame-width:100-height:100` |
  | `buttonStyle(.borderedProminent)` | `button-style-borderedProminent` |

  ### Attribute References
  To reference an attribute value, use `[attr(attribute-name)]`:

  ```html
  <Group class="offset-y:[attr(offset)]" offset="5">
  ```

  ### Complex Arguments
  Complex types (such as a gradient `ShapeStyle`) can be provided by writing out the full syntax as an argument.

  ```html
  <Rectangle class="fg-LinearGradient(colors:[.red,.blue],startPoint:.leading,endPoint:.trailing)" />
  ```

  > [!NOTE]
  > Spaces cannot be used within class names.

  ### Spaces and Underscores
  To include a space in a string argument, use and underscore `['Hello,_world!']`.
  Any underscores will be replaced with a space.

  ```html
  <Group class="navigation-title-['Hello_World']">
  ```

  If you need to include an underscore character, escape it with `\_`.

  ```html
  <Group class="navigation-title-['Hello\_World']">
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
  | `fg` | `foreground-style` |
  | `bg` | `background` |
  | `overlay--` | `overlay-content::` |
  | `bg--` | `background-content::` |
  | `mask--` | `mask-mask::` |
  | `toolbar--` | `toolbar-content::` |
  | `safe-area-inset--` | `safe-area-inset-content::` |
  """

  @modifier_names (File.read!("lib/live_view_native/swiftui/styles/modifier.names") |> String.split("\n", trim: true))
    ++ ["stroke", "mask"]

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
    "fg" => "foreground-style",
    "bg" => "background",
    "overlay--" => "overlay-content::",
    "bg--" => "background-content::",
    "mask--" => "mask-mask::",
    "toolbar--" => "toolbar-content::",
    "safe-area-inset--" => "safe-area-inset-content::",
  }

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
    kebab_name =
      modifier
      |> Macro.underscore()
      |> String.replace("_", "-")

    def class(unquote(kebab_name) <> arguments) do
      name = unquote(modifier)

      arguments =
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
      try do
        ~RULES"""
        <%= name %>(<%= arguments %>)
        """
      rescue
        _ ->
          {:unmatched, ""}
      end
    end
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
