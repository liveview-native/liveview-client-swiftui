defmodule LiveViewNativeTest.SwiftUI.TestClient do
  @moduledoc false

  defstruct tags: %{
    form: "LiveForm",
    button: "Button",
    upload_input: "VStack",
    changeables: ~w(
      ColorPicker
      DatePicker
      Picker
      MultiDatePicker
      SecureField
      Slider
      Stepper
      TextEditor
      TextField
      Toggle
    )
  }
end
