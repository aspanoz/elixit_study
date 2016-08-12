defmodule AppPhoenix.UserControllerLoginTest do
  use AppPhoenix.AcceptanceCase, async: true

  alias AppPhoenix.Factory

  setup do
    # create sample user
    role = Factory.insert(:role)
    user = Factory.insert(:user, role: role)
    {
      :ok,
      user: user,
    }
  end

  # Test login

  @tag :controller_user_login
  @tag :controller_user
  test "find admin user on /users/ page", %{session: session} do
    admin =
      session
      |> visit("/users/")
      |> take_screenshot("find_default_admin")
      |> find(".users")
      |> all(".user")
      |> List.first
      |> find(".user-name")
      |> text
    assert admin == "admin"
  end


  @tag :controller_user_login
  @tag :controller_user
  test "login as default admin", %{session: session} do
    session
    |> visit("/sessions/new")
    |> find("#login-form")
    |> fill_in("user_username", with: "admin")
    |> fill_in("user_password", with: "test")
    |> click_on("Submit")

    login_success =
      session
      |> find(".alert-info")
      |> take_screenshot("login_as_default_admin")
      |> has_text?("Sign in successful!")

    assert get_current_path(session) == "/"
    assert login_success == :true 
  end


  @tag :controller_user_login
  @tag :controller_user
  test "wrong username", %{session: session, user: user} do
    session
    |> visit("/sessions/new")
    |> find("#login-form")
    |> fill_in("user_username", with: "error")
    |> fill_in("user_password", with: user.password)
    |> take_screenshot("wrong_user_name")
    |> click_on("Submit")

    wrong_login =
      session
      |> find(".alert-danger")
      |> has_text?("Invalid username/password combination!")

    assert wrong_login == :true 
    assert get_current_path(session) == "/"
  end


  @tag :controller_user_login
  @tag :controller_user
  test "wrong user password", %{session: session, user: user} do
    session
    |> visit("/sessions/new")
    |> find("#login-form")
    |> fill_in("user_username", with: user.username)
    |> fill_in("user_password", with: "error")
    |> take_screenshot("wrong_user_password")
    |> click_on("Submit")

    wrong_passwd =
      session
      |> find(".alert-danger")
      |> has_text?("Invalid username/password combination!")

    assert wrong_passwd == :true 
    assert get_current_path(session) == "/"
  end

end
