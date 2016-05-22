defmodule AppPhoenix.UserControllerTest do
  use AppPhoenix.ConnCase

  alias AppPhoenix.User
  alias AppPhoenix.Factory

  @valid_create_attrs %{
    email: "test@test.com",
    username: "test",
    password: "test",
    password_confirmation: "test"
  }
  @valid_attrs %{
    email: "test@test.com",
    username: "test"
  }
  @invalid_attrs %{}

  setup do
    # create simple user
    user_role = Factory.create(:role)
    nonadmin_user = Factory.create(:user, role: user_role)
    some_user = Factory.create(:user, role: user_role)
    # create admin user
    admin_role = Factory.create(:role, admin: true)
    admin_user = Factory.create(:user, role: admin_role)
    {
      :ok,
      conn: conn(),
      admin_role: admin_role,
      user_role: user_role,
      some_user: some_user,
      nonadmin_user: nonadmin_user,
      admin_user: admin_user
    }
  end

  defp valid_create_attrs(role) do
    Map.put(@valid_create_attrs, :role_id, role.id)
  end

  defp login_user(conn, user) do
    post conn, session_path(conn, :create), user: %{username: user.username, password: user.password}
  end


  @tag :user_controller
  test "lists all entries on index", %{conn: conn} do
    conn = get conn, user_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing users"
  end

  @tag :user_controller
  @tag :admin
  test "renders form for new resources", %{conn: conn, admin_user: admin_user} do
    conn = login_user(conn, admin_user)
    conn = get conn, user_path(conn, :new)
    assert html_response(conn, 200) =~ "New user"
  end

  @tag :user_controller
  @tag :admin
  test "redirects from new form when not admin",
    %{conn: conn, nonadmin_user: nonadmin_user}
  do
    conn = login_user(conn, nonadmin_user)
    conn = get conn, user_path(conn, :new)
    assert get_flash(conn, :error) == "You are not authorized to create new users!"
    assert redirected_to(conn) == page_path(conn, :index)
    assert conn.halted
  end

  @tag :user_controller
  @tag :admin
  test "creates resource and redirects when data is valid",
    %{conn: conn, user_role: user_role, admin_user: admin_user}
  do
    conn = login_user(conn, admin_user)
    conn = post conn, user_path(conn, :create), user: valid_create_attrs(user_role)
    assert redirected_to(conn) == user_path(conn, :index)
    assert Repo.get_by(User, @valid_attrs)
  end

  @tag :user_controller
  @tag :admin
  test "redirects from creating user when not admin",
    %{conn: conn, user_role: user_role, nonadmin_user: nonadmin_user}
  do
    conn = login_user(conn, nonadmin_user)
    conn = post conn, user_path(conn, :create), user: valid_create_attrs(user_role)
    assert get_flash(conn, :error) == "You are not authorized to create new users!"
    assert redirected_to(conn) == page_path(conn, :index)
    assert conn.halted
  end

  @tag :user_controller
  @tag :admin
  test "does not create resource and renders errors when data is invalid",
    %{conn: conn, admin_user: admin_user}
  do
    conn = login_user(conn, admin_user)
    conn = post conn, user_path(conn, :create), user: @invalid_attrs
    assert html_response(conn, 200) =~ "New user"
  end

  @tag :user_controller
  test "shows chosen resource", %{conn: conn} do
    user = Repo.insert! %User{}
    conn = get conn, user_path(conn, :show, user)
    assert html_response(conn, 200) =~ "Show user"
  end

  @tag :user_controller
  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, user_path(conn, :show, -1)
    end
  end

  @tag :user_controller
  @tag :admin
  test "renders form for editing chosen resource when logged in as that user",
    %{conn: conn, nonadmin_user: nonadmin_user}
  do
    conn = login_user(conn, nonadmin_user)
    conn = get conn, user_path(conn, :edit, nonadmin_user)
    assert html_response(conn, 200) =~ "Edit user"
  end

  @tag :user_controller
  @tag :admin
  test "renders form for editing chosen resource when logged in as an admin",
    %{conn: conn, admin_user: admin_user, nonadmin_user: nonadmin_user}
  do
    # roles = Repo.all(Role)
    # IO.puts Kernel.inspect(roles, pretty: true)
    conn = login_user(conn, admin_user)
    conn = get conn, user_path(conn, :edit, nonadmin_user)
    assert html_response(conn, 200) =~ "Edit user"
  end

  @tag :user_controller
  @tag :admin
  test "redirects away from editing when logged in as a different user",
    %{conn: conn, nonadmin_user: nonadmin_user, admin_user: admin_user}
  do
    conn = login_user(conn, nonadmin_user)
    conn = get conn, user_path(conn, :edit, admin_user)
    assert get_flash(conn, :error) == "You are not authorized to modify that user!"
    assert redirected_to(conn) == page_path(conn, :index)
    assert conn.halted
  end

  @tag :user_controller
  @tag :admin
  test "updates chosen resource and redirects when data is valid when logged in as that user",
    %{conn: conn, nonadmin_user: nonadmin_user}
  do
    conn = login_user(conn, nonadmin_user)
    conn = put conn, user_path(conn, :update, nonadmin_user), user: @valid_create_attrs
    assert redirected_to(conn) == user_path(conn, :show, nonadmin_user)
    assert Repo.get_by(User, @valid_attrs)
  end

  @tag :user_controller
  @tag :admin
  test "updates chosen resource and redirects when data is valid when logged in as an admin",
    %{conn: conn, admin_user: admin_user}
  do
    conn = login_user(conn, admin_user)
    conn = put conn, user_path(conn, :update, admin_user), user: @valid_create_attrs
    assert redirected_to(conn) == user_path(conn, :show, admin_user)
    assert Repo.get_by(User, @valid_attrs)
  end

  @tag :user_controller
  @tag :admin
  test "does not update chosen resource when logged in as different user",
    %{conn: conn, nonadmin_user: nonadmin_user, admin_user: admin_user}
  do
    conn = login_user(conn, nonadmin_user)
    conn = put conn, user_path(conn, :update, admin_user), user: @valid_create_attrs
    assert get_flash(conn, :error) == "You are not authorized to modify that user!"
    assert redirected_to(conn) == page_path(conn, :index)
    assert conn.halted
  end

  @tag :user_controller
  @tag :admin
  test "does not update chosen resource and renders errors when data is invalid",
    %{conn: conn, nonadmin_user: nonadmin_user}
  do
    conn = login_user(conn, nonadmin_user)
    conn = put conn, user_path(conn, :update, nonadmin_user), user: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit user"
  end

  @tag :user_controller
  @tag :admin
  test "deletes chosen resource when logged in as that user",
    %{conn: conn, some_user: some_user}
  do
    conn =
      login_user(conn, some_user)
        |> delete(user_path(conn, :delete, some_user))
    assert redirected_to(conn) == user_path(conn, :index)
    refute Repo.get(User, some_user.id)
  end

  @tag :user_controller
  @tag :admin
  test "deletes chosen resource when logged in as an admin",
    %{conn: conn, some_user: some_user, admin_user: admin_user}
  do
    conn =
      login_user(conn, admin_user)
        |> delete(user_path(conn, :delete, some_user))
    assert redirected_to(conn) == user_path(conn, :index)
    refute Repo.get(User, some_user.id)
  end

  @tag :user_controller
  @tag :admin
  test "redirects away from deleting chosen resource when logged in as a different user",
     %{conn: conn, some_user: some_user, nonadmin_user: nonadmin_user}
  do
    conn =
      login_user(conn, nonadmin_user)
        |> delete(user_path(conn, :delete, some_user))
    assert get_flash(conn, :error) == "You are not authorized to modify that user!"
    assert redirected_to(conn) == page_path(conn, :index)
    assert conn.halted
  end

end
