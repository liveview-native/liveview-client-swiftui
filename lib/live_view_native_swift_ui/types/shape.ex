defmodule LiveViewNativeSwiftUi.Types.Shape do
  @derive Jason.Encoder
  defstruct [
    static: nil,
    properties: %{},
    key: nil
  ]

  use LiveViewNativePlatform.Modifier.Type
  def type, do: :map

  def cast(nil), do: nil

  @static_shapes [
    :capsule,
    :circle,
    :container_relative_shape,
    :ellipse,
    :rectangle
  ]

  # Static shape
  def cast(value) when value in @static_shapes, do: cast({value, []})

  def cast({type, opts}) when is_atom(type) and (is_list(opts) or is_map(opts)),
    do: {:ok, %__MODULE__{ static: type, properties: Enum.into(opts, %{}) }}

  # KeyName equivalent
  def cast(value) when is_atom(value) and not is_boolean(value),
    do: {:ok, %__MODULE__{ key: Atom.to_string(value) }}

  def cast(_), do: :error
end
