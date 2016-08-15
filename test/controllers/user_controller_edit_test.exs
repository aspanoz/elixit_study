defmodule AppPhoenix.UserControllerEditTest do
  use AppPhoenix.AcceptanceCase, async: true

  alias AppPhoenix.Factory

  setup do
    role = Factory.insert(:role)
    user = Factory.insert(:user, role: role)
    admin = Factory.insert(:user, role: Factory.insert(:role, admin: true))
    {
      :ok,
      user: user,
      admin: admin,
    }
  end

  @tag :controller_user_edit
  @tag :controller_user
  test "edit default admin user data by default admin", %{session: session} do

    session
    |> visit("/sessions/new")
    |> find("#login-form")
    |> fill_in("user_username", with: "admin")
    |> fill_in("user_password", with: "test")
    |> click_on("Submit")

    session
    |> visit("/users/")
    |> find(".users")
    |> all(".user")
    |> List.first
    |> click_link("Edit")
    |> take_screenshot("edit_admin")

    assert session |> find("h2") |> has_text?("Edit user") == :true 
    assert session |> find("#user_username") |> has_value?("admin") == :true 
    assert session |> find("#user_email") |> has_value?("admin@test.com") == :true 
    assert session |> find("#user_role_id") |> has_value?("2") == :true 

    session
    |> fill_in("user_username", with: "new_admin")
    |> fill_in("user_password", with: "fooboo")
    |> fill_in("user_password_confirmation", with: "fooboo")
    |> fill_in("user_email", with: "whatever@example.com")
    |> select("Role", option: "User Role")
    |> click_on("Submit")

    edit_success =
      session
      |> find(".alert-info")
      |> take_screenshot("edit_admin_done")
      |> has_text?("User updated successfully.")
    assert edit_success == :true 

    session
    |> logout
    |> visit("/sessions/new")
    |> find("#login-form")
    |> fill_in("user_username", with: "new_admin")
    |> fill_in("user_password", with: "fooboo")
    |> click_on("Submit")

    session
    |> visit("/users/")
    |> find(".users")
    |> all(".user")
    |> List.first
    |> click_link("Edit")
    |> take_screenshot("edit_admin_check")

    assert session |> find("#user_username") |> has_value?("new_admin") == :true 
    assert session |> find("#user_email") |> has_value?("whatever@example.com") == :true 
    assert session |> find("#user_role_id") |> has_value?("1") == :true 

  end




  # login as admin and
    # edit some user data
    # verify form data 
    # confirmation on role change (modal window)

  # login as simple user and
    # open and edit user data
    # redirect, then try to edit some other data
    # verify form data
    # user cant edit role

end
