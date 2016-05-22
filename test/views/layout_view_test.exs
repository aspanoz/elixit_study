defmodule AppPhoenix.LayoutViewTest do
  use AppPhoenix.ConnCase

  alias AppPhoenix.LayoutView
  alias AppPhoenix.Factory


  setup do
    user = Factory.create(:user, role: Factory.create(:role))
    {:ok, conn: conn(), user: user}
  end


  @tag :layout_view
  test "current user returns the user in the session", %{conn: conn, user: user} do
    conn = post conn, session_path(conn, :create), user: %{username: user.username, password: user.password}
    assert LayoutView.current_user(conn)
  end

  @tag :layout_view
  test "current user returns nothing if there is no user in the session", %{user: user} do
    conn = delete conn, session_path(conn, :delete, user)
    refute LayoutView.current_user(conn)
  end

end
