defmodule AppPhoenix.UserControllerTest do
  use AppPhoenix.AcceptanceCase, async: true

  alias AppPhoenix.Factory

  setup do
    # create sample user
    role = Factory.insert(:role)
    user = Factory.insert(:user, role: role)
    admin = %{ username: "admin", password: "test", email: "admin@test.com" }
    {
      :ok,
      user: user,
      admin: admin,
    }
  end

# delete user by admin
# delete user by user

  @tag :controller_user_delete
  @tag :controller_user
  test "delete user by default admin", %{session: session, scr: scr, admin: admin, user: user} do
    session
    |> login(admin)
    |> visit("/users/")
    |> xfind("//tr[contains(@class, 'user') and td[contains(@class, 'user-name')]='#{user.username}']")
    |> click_link("Delete")
    |> take_screenshot?( "delete_by_admin", scr.takeit? )

  end

end
