defmodule LiveViewNativeSwiftUi.Types.Color do
  @derive Jason.Encoder
  defstruct [
    :blue,
    :brightness,
    :create_with,
    :green,
    :hue,
    :opacity,
    :red,
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

  use LiveViewNativePlatform.Modifier.Type
  def type, do: :map

  def cast(value) when is_map(value), do: {:ok, struct(__MODULE__, value)}

  def cast(value) when is_bitstring(value),
    do: {:ok, %__MODULE__{create_with: :string, string: value}}

  def cast(value) when value in @system_colors,
    do: {:ok, %__MODULE__{create_with: :string, string: "system-#{value}"}}

  def cast({:rgb_color_space, %{white: white} = opts}),
    do: {:ok, %__MODULE__{create_with: :rgb_color_space, white: white, opacity: opts[:opacity]}}

  def cast({:rgb_color_space, %{} = opts}),
    do:
      {:ok,
       %__MODULE__{
         create_with: :rgb_color_space,
         red: opts[:red],
         green: opts[:green],
         blue: opts[:blue],
         opacity: opts[:opacity]
       }}

  def cast(_), do: :error
end
