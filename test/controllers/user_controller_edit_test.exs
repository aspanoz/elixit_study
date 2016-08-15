defmodule AppPhoenix.UserControllerEditTest do
  use AppPhoenix.AcceptanceCase, async: true

  alias AppPhoenix.Factory

  setup do
    role = Factory.insert(:role)
    user = Factory.insert(:user, role: role)
    newattr = %{ username: "fooboo", password: "fooboo", email: "fooboo@example.com" }
    admin = %{ username: "admin", password: "test", email: "admin@test.com" }
    {
      :ok,
      user: user,
      admin: admin,
      newattr: newattr
    }
  end


  @tag :controller_user_edit
  @tag :controller_user
  test "edit default admin user data by default admin", %{session: session, scr: scr, newattr: newattr, admin: admin} do

    session
    |> login(admin)
    |> visit("/users/")
    |> find(".users")
    |> all(".user")
    |> List.first
    |> click_link("Edit")
    |> take_screenshot?( "edit_admin", scr.takeit? )

    assert session |> find("h2") |> has_text?("Edit user") == :true 
    assert session |> find("#user_username") |> has_value?( admin.username ) == :true 
    assert session |> find("#user_email") |> has_value?( admin.email ) == :true 
    assert session |> find("#user_role_id") |> has_value?("2") == :true 

    session
    |> fill_in("user_username", with: newattr.username)
    |> fill_in("user_password", with: newattr.password)
    |> fill_in("user_password_confirmation", with: newattr.password)
    |> fill_in("user_email", with: newattr.email)
    |> select("Role", option: "User Role")
    |> click_on("Submit")

    edit_success =
      session
      |> find(".alert-info")
      |> take_screenshot?( "edit_admin_done", scr.takeit? )
      |> has_text?("User updated successfully.")
    assert edit_success == :true 

    session
    |> logout
    |> login(newattr)
    |> visit("/users/")
    |> find(".users")
    |> all(".user")
    |> List.first
    |> click_link("Edit")
    |> take_screenshot?( "edit_admin_check", scr.takeit? )

    assert session |> find("#user_username") |> has_value?(newattr.username) == :true 
    assert session |> find("#user_email") |> has_value?( newattr.email ) == :true 
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
