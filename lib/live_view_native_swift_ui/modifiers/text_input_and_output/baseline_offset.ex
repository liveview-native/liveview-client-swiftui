defmodule LiveViewNativeSwiftUi.Modifiers.BaselineOffset do
  use LiveViewNativePlatform.Modifier

  modifier_schema "baseline_offset" do
    field :offset, :float
  end

  def params(offset) when is_number(offset), do: [offset: offset]
  def params(params), do: params
end
