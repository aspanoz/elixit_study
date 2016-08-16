defmodule AppPhoenix.UserControllerEditTest do
  use AppPhoenix.AcceptanceCase, async: true

  alias AppPhoenix.Factory

  setup do
    role = Factory.insert(:role)
    user = Factory.insert(:user, role: role)
    fillform = %{
      username: "fooboo",
      password: "fooboo",
      password_confirmation: "fooboo",
      email: "fooboo@example.com" ,
      role: "User Role"
    }
    admin = %{ username: "admin", password: "test", email: "admin@test.com" }
    {
      :ok,
      user: user,
      admin: admin,
      fillform: fillform
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


  @tag :controller_user_edit
  @tag :controller_user
  test "edit default admin user data by default admin", %{session: session, scr: scr, fillform: fillform, admin: admin} do
    session
    |> login(admin)
    |> visit("/users/")
    # |> find({:xpath, "//table[contains(@class, 'users')]"})
    # |> find({:xpath, "//tr[contains(@class, 'user') and td[contains(@class, 'user-name') ]='admin']"})
    # |> find(".users")
    |> xfind("//tr[contains(@class, 'user') and td[contains(@class, 'user-name')]='#{admin.username}']")
    |> click_link("Edit")
    |> take_screenshot?( "edit_admin", scr.takeit? )

    assert session |> find("h2") |> has_text?("Edit user") == :true
    assert session |> find("#user_username") |> has_value?( admin.username ) == :true
    assert session |> find("#user_email") |> has_value?( admin.email ) == :true
    assert session |> find("#user_role_id") |> has_value?("2") == :true

    edit_success =
      session
      |> fill_user_form( fillform )
      |> find(".alert-info")
      |> take_screenshot?( "edit_admin_done", scr.takeit? )
      |> has_text?("User updated successfully.")
    assert edit_success == :true

    session
    |> logout
    |> login(fillform)
    |> visit("/users/")
    |> xfind("//tr[contains(@class, 'user') and td[contains(@class, 'user-name')]='#{fillform.username}']")
    |> click_link("Edit")
    |> take_screenshot?( "edit_admin_check", scr.takeit? )

    assert session |> find("#user_username") |> has_value?(fillform.username) == :true
    assert session |> find("#user_email") |> has_value?( fillform.email ) == :true
    assert session |> find("#user_role_id") |> has_value?("1") == :true
  end


  @tag :controller_user_edit
  @tag :controller_user
  test "edit user data by default admin", %{session: session, scr: scr, fillform: fillform, admin: admin, user: user} do
    session
    |> login(admin)
    |> visit("/users/")
    |> xfind("//tr[contains(@class, 'user') and td[contains(@class, 'user-name')]='#{user.username}']")
    |> click_link("Edit")
    |> take_screenshot?( "edit_user_by_admin", scr.takeit? )

    edit_success =
      session
      |> fill_user_form( fillform )
      |> find(".alert-info")
      |> take_screenshot?( "edit_user_by_admin_done", scr.takeit? )
      |> has_text?("User updated successfully.")
    assert edit_success == :true

    session
    |> logout
    |> login(fillform)
    |> visit("/users/")
    |> xfind("//tr[contains(@class, 'user') and td[contains(@class, 'user-name')]='#{fillform.username}']")
    |> click_link("Edit")
    |> take_screenshot?( "edit_user_by_admin_check", scr.takeit? )

    assert session |> find("#user_username") |> has_value?(fillform.username) == :true
    assert session |> find("#user_email") |> has_value?( fillform.email ) == :true
    assert session |> find("#user_role_id") |> has_value?("1") == :true
  end


  @tag :controller_user_edit
  @tag :controller_user
  test "form with empty user name", %{session: session, scr: scr, fillform: fillform, admin: admin} do
    session
    |> login(admin)
    |> visit("/users/")
    |> xfind("//tr[contains(@class, 'user') and td[contains(@class, 'user-name')]='#{admin.username}']")
    |> click_link("Edit")

    no_user_name =
      session
      |> fill_user_form( %{ fillform | username: ""} )
      |> find("div.alert-danger") #alert in form
      |> take_screenshot?( "edit_no_user_name", scr.takeit? )
      |> has_text?("Oops, something went wrong! Please check the errors below.")
    assert no_user_name == :true
    assert session |> find(".help-block") |> has_text?("can't be blank") == :true
  end


  @tag :controller_user_edit
  @tag :controller_user
  test "form with empty email", %{session: session, scr: scr, fillform: fillform, admin: admin} do
    session
    |> login(admin)
    |> visit("/users/")
    |> xfind("//tr[contains(@class, 'user') and td[contains(@class, 'user-name')]='#{admin.username}']")
    |> click_link("Edit")

    no_user_name =
      session
      |> fill_user_form( %{fillform | email: ""} )
      |> find("div.alert-danger") #alert in form
      |> take_screenshot?( "edit_no_email", scr.takeit? )
      |> has_text?("Oops, something went wrong! Please check the errors below.")
    assert no_user_name == :true
    assert session |> find(".help-block") |> has_text?("can't be blank") == :true
  end


  @tag :controller_user_edit
  @tag :controller_user
  test "form with empty password", %{session: session, scr: scr, fillform: fillform, admin: admin} do
    session
    |> login(admin)
    |> visit("/users/")
    |> xfind("//tr[contains(@class, 'user') and td[contains(@class, 'user-name')]='#{admin.username}']")
    |> click_link("Edit")

    no_user_name =
      session
      |> fill_user_form( %{fillform | password: ""} )
      |> find("div.alert-danger") #alert in form
      |> take_screenshot?( "edit_no_password", scr.takeit? )
      |> has_text?("Oops, something went wrong! Please check the errors below.")
    assert no_user_name == :true
    assert session |> find(".help-block") |> has_text?("can't be blank") == :true
  end


  @tag :controller_user_edit
  @tag :controller_user
  test "form with empty password confirmation", %{session: session, scr: scr, fillform: fillform, admin: admin} do
    session
    |> login(admin)
    |> visit("/users/")
    |> xfind("//tr[contains(@class, 'user') and td[contains(@class, 'user-name')]='#{admin.username}']")
    |> click_link("Edit")

    no_user_name =
      session
      |> fill_user_form( %{fillform | password_confirmation: ""} )
      |> find("div.alert-danger") #alert in form
      |> take_screenshot?( "edit_no_password_confirmation", scr.takeit? )
      |> has_text?("Oops, something went wrong! Please check the errors below.")
    assert no_user_name == :true
    assert session |> find(".help-block") |> has_text?("can't be blank") == :true
  end


  # login as admin and
    # confirmation on role change (modal window)


  @tag :controller_user_edit
  @tag :controller_user
  test "form with wrong password confirmation", %{session: session, scr: scr, fillform: fillform, admin: admin} do
    session
    |> login(admin)
    |> visit("/users/")
    |> xfind("//tr[contains(@class, 'user') and td[contains(@class, 'user-name')]='#{admin.username}']")
    |> click_link("Edit")

    no_user_name =
      session
      |> fill_user_form( %{fillform | password_confirmation: "whatever"} )
      |> find("div.alert-danger") #alert in form
      |> take_screenshot?( "edit_wrong_password_confirmation", scr.takeit? )
      |> has_text?("Oops, something went wrong! Please check the errors below.")
    assert no_user_name == :true
    assert session |> find(".help-block") |> has_text?("can't be blank") == :true
  end


  @tag :controller_user_edit
  @tag :controller_user
  test "edit user data by user", %{session: session, scr: scr, fillform: fillform, user: user} do
    session
    |> login(user)
    |> visit("/users/")
    |> xfind("//tr[contains(@class, 'user') and td[contains(@class, 'user-name')]='#{user.username}']")
    |> click_link("Edit")
    |> take_screenshot?( "edit_user", scr.takeit? )

    assert session |> find("h2") |> has_text?("Edit user") == :true
    assert session |> find("#user_username") |> has_value?( user.username ) == :true
    assert session |> find("#user_email") |> has_value?( user.email ) == :true
    assert session |> has_no_css?("#user_role_id") == :true

    edit_success =
      session
      |> fill_user_form( fillform )
      |> find(".alert-info")
      |> take_screenshot?( "edit_user_done", scr.takeit? )
      |> has_text?("User updated successfully.")
    assert edit_success == :true

    session
    |> logout
    |> login(fillform)
    |> visit("/users/")
    |> xfind("//tr[contains(@class, 'user') and td[contains(@class, 'user-name')]='#{fillform.username}']")
    |> click_link("Edit")
    |> take_screenshot?( "edit_user_check", scr.takeit? )

    assert session |> find("#user_username") |> has_value?(fillform.username) == :true
    assert session |> find("#user_email") |> has_value?( fillform.email ) == :true
  end


  @tag :controller_user_edit
  @tag :controller_user
  test "try to edit admin by user and be redirected", %{session: session, scr: scr, user: user, admin: admin} do
    session
    |> login(user)
    |> visit("/users/")
    |> xfind("//tr[contains(@class, 'user') and td[contains(@class, 'user-name')]='#{admin.username}']")
    |> click_link("Edit")

    be_redirected =
      session
      |> take_screenshot?( "edit_admin_by_user", scr.takeit? )
      |> find(".alert-danger")
      |> take_screenshot?( "simple_user_redirect", scr.takeit? )
      |> has_text?("You are not authorized to modify that user!")

    assert be_redirected == :true
    assert get_current_path(session) == "/"
  end

end
