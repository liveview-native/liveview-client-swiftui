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

  def params(submit_label) when is_atom(submit_label) and not is_boolean(submit_label) and not is_nil(submit_label), do: [submit_label: submit_label]
end
