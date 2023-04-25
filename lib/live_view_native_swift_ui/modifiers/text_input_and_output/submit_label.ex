defmodule LiveViewNativeSwiftUi.Modifiers.SubmitLabel do
  use LiveViewNativePlatform.Modifier

  modifier_schema "submit_label" do
    field(:submit_label, Ecto.Enum, values: ~w(
      done
      go
      send
      join
      route
      search
      return
      next
      continue
    )a)
  end
end
