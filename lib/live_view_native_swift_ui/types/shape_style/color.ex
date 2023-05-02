defmodule LiveViewNativeSwiftUi.Types.Color do
  import LiveViewNativeSwiftUi.Utils, only: [encode_key: 1]

  @derive Jason.Encoder
  defstruct [
    :blue,
    :brightness,
    :green,
    :hue,
    :opacity,
    :red,
    :rgb_color_space,
    :saturation,
    :string,
    :white
  ]

  @system_colors ~w(
    black
    blue
    brown
    clear
    cyan
    gray
    green
    indigo
    mint
    orange
    pink
    purple
    red
    teal
    white
    yellow
    accent
    primary
    secondary
  )a

  @rgb_color_spaces ~w(
    srgb
    srgb_linear
    display_p3
  )a

  use LiveViewNativePlatform.Modifier.Type
  def type, do: :map

  def cast(value) when is_map(value), do: {:ok, struct(__MODULE__, value)}

  def cast(value) when is_bitstring(value),
    do: {:ok, %__MODULE__{string: value}}

  def cast(value) when value in @system_colors,
    do: {:ok, %__MODULE__{string: "system-#{value}"}}

  def cast({rgb_color_space, %{white: white} = opts}) when rgb_color_space in @rgb_color_spaces,
    do: {:ok, %__MODULE__{rgb_color_space: encode_key(rgb_color_space), white: white, opacity: opts[:opacity]}}

  def cast({rgb_color_space, %{} = opts}) when rgb_color_space in @rgb_color_spaces,
    do:
      {:ok,
       %__MODULE__{
         rgb_color_space: encode_key(rgb_color_space),
         red: opts[:red],
         green: opts[:green],
         blue: opts[:blue],
         opacity: opts[:opacity]
       }}

  def cast(_), do: :error
end
