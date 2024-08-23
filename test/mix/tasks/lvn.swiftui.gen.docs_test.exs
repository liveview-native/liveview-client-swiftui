defmodule Mix.Tasks.Lvn.Swiftui.Gen.DocsTest do
	use ExUnit.Case
	doctest Mix.Tasks.Lvn.Swiftui.Gen.Docs
	alias Mix.Tasks.Lvn.Swiftui.Gen.Docs

	@example_cheatsheet_md File.read!("test/support/data/cheatsheet.md")
	@example_doc_md File.read!("test/support/data/doc.md")
	@example_json File.read!("test/support/data/view.json")

	test "markdown/1" do
		view_data = Jason.decode!(@example_json)

		assert ignore_whitespace(Docs.markdown(view_data)) =~ ignore_whitespace(@example_doc_md)
	end

	test "cheatsheet/1" do
		view_data = Jason.decode!(@example_json)

		assert ignore_whitespace(Docs.cheatsheet(view_data)) =~ ignore_whitespace(@example_cheatsheet_md)
	end

	defp ignore_whitespace(string), do: string |> String.replace(" ", "") |> String.replace("\t", "")
end
