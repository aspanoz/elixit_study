defmodule AppPhoenix.UserControllerLoginTest do
  use AppPhoenix.AcceptanceCase, async: true

  setup do
    # create sample user
    admin = %{ username: "admin", password: "test", email: "admin@test.com" }
    {
      :ok,
      admin: admin,
    }
  end

  # Test login

  @tag :controller_user_login
  @tag :controller_user
  test "find admin user on /users/ page", %{session: session, scr: scr} do
    admin =
      session
      |> visit("/users/")
      |> take_screenshot?( "find_default_admin", scr.takeit? )
      |> find(".users")
      |> xfind("//tr[contains(@class, 'user') and td[contains(@class, 'user-name') ]='admin']")
      |> find(".user-name")
      |> text
    assert admin == "admin"
  end


  @tag :controller_user_login
  @tag :controller_user
  test "login as default admin", %{session: session, scr: scr, admin: admin} do

    login_success =
      session
      |> login(admin)
      |> find(".alert-info")
      |> take_screenshot?( "login_as_default_admin", scr.takeit? )
      |> has_text?("Sign in successful!")

    assert get_current_path(session) == "/"
    assert login_success == :true
  end


  @tag :controller_user_login
  @tag :controller_user
  test "wrong username", %{session: session, scr: scr, admin: admin} do

    wrong_login =
      session
      |> login( %{admin | username: "error"} )
      |> take_screenshot?( "wrong_user_name", scr.takeit? )
      |> find(".alert-danger")
      |> has_text?("Invalid username/password combination!")

    assert wrong_login == :true
    assert get_current_path(session) == "/"
  end


  @tag :controller_user_login
  @tag :controller_user
  test "wrong user password", %{session: session, scr: scr, admin: admin} do

    wrong_passwd =
      session
      |> login( %{admin | password: "error"} )
      |> take_screenshot?( "wrong_user_password", scr.takeit? )
      |> find(".alert-danger")
      |> has_text?("Invalid username/password combination!")

    assert wrong_passwd == :true
    assert get_current_path(session) == "/"
  end

end
