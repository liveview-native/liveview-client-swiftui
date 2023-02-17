defmodule LiveViewNativeSwiftUi.Types.GridItem do
  @derive Jason.Encoder
  defstruct [:fixed, :flexible, :adaptive, :spacing, :alignment]

  def fixed(
    size,
    spacing \\ nil,
    alignment \\ nil
  ), do: %__MODULE__{ fixed: size, spacing: spacing, alignment: alignment }
  def flexible(
    minimum \\ 10,
    maximum \\ Float.max_finite(),
    spacing \\ nil,
    alignment \\ nil
  ), do: %__MODULE__{ flexible: %{ :minimum => minimum, :maximum => maximum}, spacing: spacing, alignment: alignment }
  def adaptive(
    minimum,
    maximum \\ Float.max_finite(),
    spacing \\ nil,
    alignment \\ nil
  ), do: %__MODULE__{ adaptive: %{ :minimum => minimum, :maximum => maximum}, spacing: spacing, alignment: alignment }

  defimpl Phoenix.HTML.Safe do
    def to_iodata(data) do
      data
        |> Map.from_struct()
        |> Jason.encode!()
        |> Phoenix.HTML.Engine.html_escape()
    end
  end
end
