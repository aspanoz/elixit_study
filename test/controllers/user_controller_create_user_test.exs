defmodule AppPhoenix.UserControllerCreateUserTest do
  use AppPhoenix.AcceptanceCase, async: true

  alias AppPhoenix.Factory

  setup do
    # create sample user
    role = Factory.insert(:role)
    user = Factory.insert(:user, role: role)
    admin = Factory.insert(:user, role: Factory.insert(:role, admin: true))
    {
      :ok,
      user: user,
      admin: admin,
    }
  end

  defp login(session, user) do
    session
    |> visit("/sessions/new")
    |> find("#login-form")
    |> fill_in("user_username", with: user.username)
    |> fill_in("user_password", with: user.password)
    |> click_on("Submit")

    session
  end

  defp logout(session) do
    session
    |> visit("/")
    |> click_link("Log out")
    session
  end


  # Test create user

  @tag :controller_user_create
  @tag :controller_user
  test "create sample user and test it`s login", %{session: session, admin: admin} do
    session
    |> login(admin)
    |> visit("/users/new")
    |> fill_in("user_username", with: "whatever")
    |> fill_in("user_password", with: "test")
    |> fill_in("user_password_confirmation", with: "test")
    |> fill_in("user_email", with: "whatever@example.com")
    |> select("Role", option: "User Role")
    |> click_on("Submit")

      
    assert session |> find(".alert-info") |> has_text?("User created successfully.") == :true 

    session
    |> logout
    |> visit("/sessions/new")
    |> find("#login-form")
    |> fill_in("user_username", with: "whatever")
    |> fill_in("user_password", with: "test")
    |> click_on("Submit")

    login_success =
      session
      |> find(".alert-info")
      |> take_screenshot("create_user")
      |> has_text?("Sign in successful!")

    assert login_success == :true 
  end


  @tag :controller_user_create
  @tag :controller_user
  test "login sample user and be redirected when try to create new user", %{session: session, user: user} do
    login_success =
      session
      |> login(user)
      |> find(".alert-info")
      |> has_text?("Sign in successful!")

    be_redirected =
      session
      |> visit("/users/new")
      |> find(".alert-danger")
      |> take_screenshot("simple_user_redirect")
      |> has_text?("You are not authorized to create new users!")

    assert login_success == :true 
    assert be_redirected == :true 
    assert get_current_path(session) == "/"
  end


  @tag :controller_user_create
  @tag :controller_user
  test "create admin user and test it`s login", %{session: session, admin: admin} do
    session
    |> login(admin)
    |> visit("/users/new")
    |> fill_in("user_username", with: "another_admin")
    |> fill_in("user_password", with: "test")
    |> fill_in("user_password_confirmation", with: "test")
    |> fill_in("user_email", with: "another_admin@example.com")
    |> select("Role", option: "Admin Role")
    |> click_on("Submit")

    assert session |> find(".alert-info") |> has_text?("User created successfully.") == :true 

    session
    |> logout
    |> visit("/sessions/new")
    |> find("#login-form")
    |> fill_in("user_username", with: "another_admin")
    |> fill_in("user_password", with: "test")
    |> click_on("Submit")

    assert session |> find(".alert-info") |> has_text?("Sign in successful!") == :true 
  end


  @tag :controller_user_create
  @tag :controller_user
  test "create user without user name", %{session: session, admin: admin} do
    session
    |> login(admin)
    |> visit("/users/new")
    |> fill_in("user_password", with: "test")
    |> fill_in("user_password_confirmation", with: "test")
    |> fill_in("user_email", with: "whatever@example.com")
    |> select("Role", option: "User Role")
    |> click_on("Submit")

    assert get_current_path(session) == "/users"

    no_user_name =
      session
      |> find("div.alert-danger") #alert in form
      |> take_screenshot("no_user_name")
      |> has_text?("Oops, something went wrong! Please check the errors below.")

    assert no_user_name == :true 

    help_block =
      session
      |> find(".help-block")
      |> has_text?("can't be blank")

    assert help_block == :true 

  end


  @tag :controller_user_create
  @tag :controller_user
  test "create user without email", %{session: session, admin: admin} do
    session
    |> login(admin)
    |> visit("/users/new")
    |> fill_in("user_username", with: "test")
    |> fill_in("user_password", with: "test")
    |> fill_in("user_email", with: "")
    |> fill_in("user_password_confirmation", with: "test")
    |> select("Role", option: "User Role")
    |> click_on("Submit")

    assert get_current_path(session) == "/users"

    no_email =
      session
      |> find("div.alert-danger") #alert in form
      |> take_screenshot("no_email")
      |> has_text?("Oops, something went wrong! Please check the errors below.")

    assert no_email == :true 

    help_block =
      session
      |> find(".help-block")
      |> has_text?("can't be blank")

    assert help_block == :true 

  end


  @tag :controller_user_create
  @tag :controller_user
  test "create user with wrong password confirmatio", %{session: session, admin: admin} do
    session
    |> login(admin)
    |> visit("/users/new")
    |> fill_in("user_username", with: "test")
    |> fill_in("user_password", with: "test")
    |> fill_in("user_email", with: "whatever@example.com")
    |> select("Role", option: "User Role")
    |> click_on("Submit")

    assert get_current_path(session) == "/users"

    no_password_confirmation =
      session
      |> find("div.alert-danger") #alert in form
      |> take_screenshot("no_password_confirmation")
      |> has_text?("Oops, something went wrong! Please check the errors below.")

    assert no_password_confirmation == :true 

    help_block =
      session
      |> find(".help-block")
      |> has_text?("can't be blank")

    assert help_block == :true 

  end

end
