defmodule AppPhoenix.PostViewTest do
  use AppPhoenix.ConnCase, async: true

  @tag :post_view
  test "converts markdown to html" do
    {:safe, result} = AppPhoenix.PostView.markdown("**bold me**")
    assert String.contains? result, "<strong>bold me</strong>"
  end

  @tag :post_view
  test "leaves text with no markdown alone" do
    {:safe, result} = AppPhoenix.PostView.markdown("leave me alone")
    assert String.contains? result, "leave me alone"
  end
end
