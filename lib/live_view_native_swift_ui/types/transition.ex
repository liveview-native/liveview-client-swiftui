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
  def cast({:asymmetric, [insertion: insertion, removal: removal]}) do
    {:ok, i} = cast(insertion)
    {:ok, r} = cast(removal)
    {:ok, %__MODULE__{ type: :asymmetric, properties: %{ insertion: i, removal: r } }}
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
end
