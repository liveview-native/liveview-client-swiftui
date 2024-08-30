defmodule LiveViewNative.SwiftUITest do
  use ExUnit.Case

  alias LiveViewNative.SwiftUI

  describe "version normalization" do
    test "normalize_os_version" do
      assert [1, 2, 3] = SwiftUI.normalize_os_version("1.2.3")
    end

    test "normalize_app_version" do
      assert [1, 2, 3] = SwiftUI.normalize_app_version("1.2.3")
    end
  end
end
