defmodule LiveViewNativeSwiftUi.Modifiers.AspectRatio do
  use LiveViewNativePlatform.Modifier

  modifier_schema "aspect_ratio" do
    field :aspect_ratio, {:array, :float}, default: [1.0, 1.0]
    field :content_mode, Ecto.Enum, values: ~w(fill fit)a
  end

  def params(aspect_ratio, params) when is_list(params) or is_map(params), do: [aspect_ratio: aspect_ratio, content_mode: params[:content_mode]]
  def params(params), do: params
end
