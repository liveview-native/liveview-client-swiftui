defmodule LiveViewNativeSwiftUi.Modifiers.FileImporter do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.{NativeBindingName, UploadConfig}

  modifier_schema "file_importer" do
    field :is_presented, NativeBindingName
    field :upload, UploadConfig
  end
end
