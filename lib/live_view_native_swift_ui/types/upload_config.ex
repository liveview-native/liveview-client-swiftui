defmodule LiveViewNativeSwiftUi.Types.UploadConfig do
  @derive Jason.Encoder
  defstruct [
    :name,
    :accept,
    :ref,
    :max_entries,
    :chunk_size
  ]

  use LiveViewNativePlatform.Modifier.Type
  def type, do: :map

  def cast(upload_config) when is_struct(upload_config, Phoenix.LiveView.UploadConfig),
    do: {:ok, struct(__MODULE__, Map.from_struct(upload_config))}
  def cast(_), do: :error
end
