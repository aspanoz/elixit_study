defmodule AppPhoenix.LayoutViewTest do
  use AppPhoenix.ConnCase

  alias AppPhoenix.LayoutView
  alias AppPhoenix.Factory


  setup do
    user = Factory.insert(:user, role: Factory.insert(:role))
    {
      :ok,
      conn: build_conn(),
      user: user
    }
  end


  @tag :view_layout
  test "current user returns the user in the session",
    %{conn: conn, user: user}
  do
    conn = conn
      |> post(
        session_path(conn, :create),
        user: %{username: user.username, password: user.password}
      )
    assert LayoutView.current_user(conn)
  end

  @tag :view_layout
    test "current user returns nothing if there is no user in the session",
  %{user: user}
  do
    conn = build_conn
      |> delete(session_path(build_conn, :delete, user))
    refute LayoutView.current_user(conn)
  end

end
