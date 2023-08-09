defmodule LiveViewNativeSwiftUi.Types.Transition do
  @derive Jason.Encoder
  defstruct [:type, :properties]

  use LiveViewNativePlatform.Modifier.Type
  def type, do: :map

  alias LiveViewNativeSwiftUi.Types.Animation

  def cast(combined) when is_list(combined) and length(combined) > 0 do
    {:ok, %__MODULE__{ type: :combined, properties: %{ transitions: Enum.map(combined, fn t -> elem(cast(t), 1) end) } }}
  end

  def cast(value) when is_atom(value), do: {:ok, %__MODULE__{ type: value, properties: %{} }}

  def cast({:asymmetric = type, [insertion: insertion, removal: removal]}) do
    {:ok, i} = cast(insertion)
    {:ok, r} = cast(removal)
    {:ok, %__MODULE__{ type: type, properties: %{ insertion: i, removal: r } }}
  end

  def cast({
    :modifier,
    [
      active: %LiveViewNativePlatform.Env{ modifiers: active },
      identity: %LiveViewNativePlatform.Env{ modifiers: identity }
    ]
  }) do
    {:ok, %__MODULE__{
      type: :modifier,
      properties: %{
        active: Phoenix.HTML.Safe.to_iodata(active) |> IO.iodata_to_binary,
        identity: Phoenix.HTML.Safe.to_iodata(identity) |> IO.iodata_to_binary
      }
    }}
  end

  def cast({:symbol_effect = type, effect}), do: cast({type, effect, []})
  def cast({:symbol_effect = type, effect, options}) when is_list(options) do
    {:ok, %__MODULE__{ type: type, properties: %{ effect: effect, options: Enum.map(options, &cast_symbol_effect_option/1) } }}
  end

  def cast({value, [ {k, _} | _ ] = properties}) when is_atom(value) and is_atom(k) do
    {:ok, %__MODULE__{ type: value, properties: Enum.into(properties, %{}) }}
  end

  def cast({transition, animation}) do
    {:ok, t} = cast(transition)
    case Animation.cast(animation) do
      {:ok, a} ->
        {:ok, %__MODULE__{ type: :animation, properties: %{ transition: t, animation: a } }}
      :error ->
        :error
    end
  end

  def cast(_), do: :error

  def cast_modifier({type, properties}) when is_list(properties), do: %{ type: type, properties: Enum.into(properties, %{}) }
  def cast_modifier({type, properties}), do: %{ type: type, properties: properties }

  def cast_symbol_effect_option(type) when is_atom(type), do: Atom.to_string(type)
  def cast_symbol_effect_option({type, properties}) when is_atom(type) and is_list(properties) do
    %{ type: type, properties: Enum.into(properties, %{}) }
  end
  def cast_symbol_effect_option({type, properties}) when is_atom(type) do
    %{ type: type, properties: properties }
  end
end
