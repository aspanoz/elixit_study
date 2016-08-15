defmodule AppPhoenix.UserControllerCreateUserTest do
  use AppPhoenix.AcceptanceCase, async: true

  alias AppPhoenix.Factory

  setup do
    # create sample user
    role = Factory.insert(:role)
    user = Factory.insert(:user, role: role)
    admin = %{ username: "admin", password: "test", email: "admin@test.com" }
    newattr = %{
      username: "fooboo",
      password: "fooboo",
      password_confirmation: "fooboo",
      email: "fooboo@example.com" ,
      role: "User Role"
    }
    {
      :ok,
      user: user,
      admin: admin,
      newattr: newattr
    }
  end

  def fill_user_form(session, attr) do
    session
    |> fill_in("user_username", with: attr.username)
    |> fill_in("user_password", with: attr.password)
    |> fill_in("user_password_confirmation", with: attr.password_confirmation)
    |> fill_in("user_email", with: attr.email)
    |> select("Role", option: attr.role)
    |> click_on("Submit")
    session
  end

  # Test create user

  @tag :controller_user_create
  @tag :controller_user
  test "create sample user and test it`s login", %{session: session, scr: scr, admin: admin, newattr: newattr} do
    session
    |> login(admin)
    |> visit("/users/new")
    |> fill_user_form( newattr )

    assert session |> find(".alert-info") |> has_text?("User created successfully.") == :true

    login_success =
      session
      |> logout
      |> login(newattr)
      |> find(".alert-info")
      |> take_screenshot?( "create_user", scr.takeit? )
      |> has_text?("Sign in successful!")

    assert login_success == :true
  end


  @tag :controller_user_create
  @tag :controller_user
  test "login sample user and be redirected when try to create new user", %{session: session, scr: scr, user: user} do
    login_success =
      session
      |> login(user)
      |> find(".alert-info")
      |> has_text?("Sign in successful!")

    be_redirected =
      session
      |> visit("/users/new")
      |> find(".alert-danger")
      |> take_screenshot?( "simple_user_redirect", scr.takeit? )
      |> has_text?("You are not authorized to create new users!")

    assert login_success == :true
    assert be_redirected == :true
    assert get_current_path(session) == "/"
  end


  @tag :controller_user_create
  @tag :controller_user
  test "create admin user and test it`s login", %{session: session, scr: scr, admin: admin, newattr: newattr} do
    session
    |> login(admin)
    |> visit("/users/new")
    |> fill_user_form( %{newattr | role: "Admin Role"} )
    |> take_screenshot?( "create_admin_user", scr.takeit? )

    assert session |> find(".alert-info") |> has_text?("User created successfully.") == :true

    session
    |> logout
    |> login(newattr)

    assert session |> find(".alert-info") |> has_text?("Sign in successful!") == :true

    session
    |> visit("/users/new") # only admin user can visit this page
    assert get_current_path(session) == "/users/new"
  end


  @tag :controller_user_create
  @tag :controller_user
  test "create user without user name", %{session: session, scr: scr, admin: admin, newattr: newattr} do
    session
    |> login(admin)
    |> visit("/users/new")
    |> fill_user_form( %{newattr | username: ""} )

    assert get_current_path(session) == "/users"

    no_user_name =
      session
      |> find("div.alert-danger") #alert in form
      |> take_screenshot?( "no_user_name", scr.takeit? )
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
  test "create user without email", %{session: session, scr: scr, admin: admin, newattr: newattr} do
    session
    |> login(admin)
    |> visit("/users/new")
    |> fill_user_form( %{newattr | email: ""} )

    assert get_current_path(session) == "/users"

    no_email =
      session
      |> find("div.alert-danger") #alert in form
      |> take_screenshot?( "no_email", scr.takeit? )
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
  test "create user with empty password confirmation", %{session: session, scr: scr, admin: admin, newattr: newattr} do
    session
    |> login(admin)
    |> visit("/users/new")
    |> fill_user_form( %{newattr | password_confirmation: ""} )

    assert get_current_path(session) == "/users"

    no_password_confirmation =
      session
      |> find("div.alert-danger") #alert in form
      |> take_screenshot?( "no_password_confirmation", scr.takeit? )
      |> has_text?("Oops, something went wrong! Please check the errors below.")

    assert no_password_confirmation == :true

    help_block =
      session
      |> find(".help-block")
      |> has_text?("can't be blank")

    assert help_block == :true
  end


  # test "create user with wrong password confirmation", %{session: session, scr: scr, admin: admin, newattr: newattr} do

end
