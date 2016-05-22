defmodule AppPhoenix.SessionControllerTest do
  use AppPhoenix.ConnCase

  alias AppPhoenix.Factory

  setup do
    role = Factory.create(:role)
    user = Factory.create(:user, role: role)
    {
      :ok,
      user: user,
      conn: conn()
    }
  end


  @tag :session_controller
  test "shows the login form", %{conn: conn} do
    conn = get conn, session_path(conn, :new)
    assert html_response(conn, 200) =~ "Login"
  end


  @tag :session_controller
  test "creates a new user session for a valid user", %{conn: conn, user: user} do
    conn = post conn, session_path(conn, :create), user: %{username: user.username, password: user.password}
    assert get_session(conn, :current_user)
    assert get_flash(conn, :info) == "Sign in successful!"
    assert redirected_to(conn) == page_path(conn, :index)
  end


  @tag :session_controller
  test "does not create a session with a bad login", %{conn: conn, user: user} do
    conn = post conn, session_path(conn, :create), user: %{username: user.username, password: "wrong"}

    refute get_session(conn, :current_user)
    assert get_flash(conn, :error) == "Invalid username/password combination!"
    assert redirected_to(conn) == page_path(conn, :index)
  end


  @tag :session_controller
  test "does not create a session if user does not exist", %{conn: conn} do
    conn = post conn, session_path(conn, :create), user: %{username: "foo", password: "wrong"}

    assert get_flash(conn, :error) == "Invalid username/password combination!"
    assert redirected_to(conn) == page_path(conn, :index)
  end


  @tag :session_controller
  test "deletes the user session", %{conn: conn, user: user} do
    conn = delete conn, session_path(conn, :delete, user)
    refute get_session(conn, :current_user)
    assert get_flash(conn, :info) == "Signed out successfully!"
    assert redirected_to(conn) == page_path(conn, :index)
  end

end
