defmodule LiveViewNativeSwiftUi.Types.Font do
  @derive Jason.Encoder
  defstruct [:type, :properties, :modifiers]

  use LiveViewNativePlatform.Modifier.Type
  def type, do: :map

  def cast({:system, style}) when is_atom(style), do: cast({:system, style, [], []})
  def cast({:system, style, properties}) when is_atom(style), do: cast({:system, style, properties, []})
  def cast({:system, style, properties, modifiers}) when is_atom(style) do
    {:ok, %__MODULE__{ type: :system, properties: Enum.into(Keyword.merge([style: style], properties), %{}), modifiers: Enum.map(modifiers, &cast_modifier/1) }}
  end
  def cast({:system, [{:size, _} | _] = properties}), do: cast({:system, properties, []})
  def cast({:system, [{:size, _} | _] = properties, modifiers}) do
    {:ok, %__MODULE__{ type: :system, properties: properties, modifiers: Enum.map(modifiers, &cast_modifier/1) }}
  end

  def cast({:custom, name, [fixed_size: fixed_size]}), do: cast({:custom, name, [fixed_size: fixed_size], []})
  def cast({:custom, name, [fixed_size: fixed_size], modifiers}), do: {:ok, %__MODULE__{ type: :custom, properties: %{ name: name, fixed_size: fixed_size }, modifiers: Enum.map(modifiers, &cast_modifier/1) }}
  def cast({:custom, name, [size: size, relative_to: style]}), do: cast({:custom, name, [size: size, relative_to: style], []})
  def cast({:custom, name, [size: size, relative_to: style], modifiers}), do: {:ok, %__MODULE__{ type: :custom, properties: %{ name: name, size: size, style: style }, modifiers: Enum.map(modifiers, &cast_modifier/1) }}
  def cast({:custom, name, [size: size]}), do: cast({:custom, name, [size: size], []})
  def cast({:custom, name, [size: size], modifiers}), do: {:ok, %__MODULE__{ type: :custom, properties: %{ name: name, size: size }, modifiers: Enum.map(modifiers, &cast_modifier/1) }}

  def cast(_), do: :error

  def cast_modifier(type) when is_atom(type), do: %{ type: type, properties: %{} }
  def cast_modifier({type, properties}) when is_list(properties), do: %{ type: type, properties: Enum.into(properties, %{}) }
  def cast_modifier({type, properties}), do: %{ type: type, properties: properties }
end
