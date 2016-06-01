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
    user_role = Factory.insert(:role)
    nonadmin_user = Factory.insert(:user, role: user_role)
    some_user = Factory.insert(:user, role: user_role)
    # create admin user
    admin_role = Factory.insert(:role, admin: true)
    admin_user = Factory.insert(:user, role: admin_role)
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
    post(
      conn,
      session_path(conn, :create),
      user: %{username: user.username, password: user.password}
    )
  end


  @tag :controller_user
  test "lists all entries on index", %{conn: conn} do
    conn = get conn, user_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing users"
  end

  @tag :controller_user
  @tag :admin
  test "renders form for new resources",
    %{conn: conn, admin_user: admin_user}
  do
    conn = login_user(conn, admin_user)
    conn = get conn, user_path(conn, :new)
    assert html_response(conn, 200) =~ "New user"
  end

  @tag :controller_user
  @tag :admin
  test "redirects from new form when not admin",
    %{conn: conn, nonadmin_user: nonadmin_user}
  do
    conn = login_user(conn, nonadmin_user)
    conn = get conn, user_path(conn, :new)
    flash = "You are not authorized to create new users!"
    assert get_flash(conn, :error) == flash
    assert redirected_to(conn) == page_path(conn, :index)
    assert conn.halted
  end

  @tag :controller_user
  @tag :admin
  test "creates resource and redirects when data is valid",
    %{conn: conn, user_role: user_role, admin_user: admin_user}
  do
    conn = login_user(conn, admin_user)
    conn = post(
      conn,
      user_path(conn, :create),
      user: valid_create_attrs(user_role)
    )
    assert redirected_to(conn) == user_path(conn, :index)
    assert Repo.get_by(User, @valid_attrs)
  end

  @tag :controller_user
  @tag :admin
  test "redirects from creating user when not admin",
    %{conn: conn, user_role: user_role, nonadmin_user: nonadmin_user}
  do
    conn = login_user(conn, nonadmin_user)
    conn = post(
      conn,
      user_path(conn, :create),
      user: valid_create_attrs(user_role)
    )
    flash = "You are not authorized to create new users!"
    assert get_flash(conn, :error) == flash
    assert redirected_to(conn) == page_path(conn, :index)
    assert conn.halted
  end

  @tag :controller_user
  @tag :admin
  test "does not create resource and renders errors when data is invalid",
    %{conn: conn, admin_user: admin_user}
  do
    conn = login_user(conn, admin_user)
    conn = post conn, user_path(conn, :create), user: @invalid_attrs
    assert html_response(conn, 200) =~ "New user"
  end

  @tag :controller_user
  test "shows chosen resource", %{conn: conn} do
    user = Repo.insert! %User{}
    conn = get conn, user_path(conn, :show, user)
    assert html_response(conn, 200) =~ "Show user"
  end


  @tag :controller_user
  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, user_path(conn, :show, -1)
    end
  end

  @tag :controller_user
  @tag :admin
  test "renders form for editing when logged in as that user",
    %{conn: conn, nonadmin_user: nonadmin_user}
  do
    conn = login_user(conn, nonadmin_user)
    conn = get conn, user_path(conn, :edit, nonadmin_user)
    assert html_response(conn, 200) =~ "Edit user"
  end

  @tag :controller_user
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

  @tag :controller_user
  @tag :admin
  test "redirects away from editing when logged in as a different user",
    %{conn: conn, nonadmin_user: nonadmin_user, admin_user: admin_user}
  do
    conn = login_user(conn, nonadmin_user)
    conn = get conn, user_path(conn, :edit, admin_user)
    flash = "You are not authorized to modify that user!"
    assert get_flash(conn, :error) == flash
    assert redirected_to(conn) == page_path(conn, :index)
    assert conn.halted
  end

  @tag :controller_user
  @tag :admin
  test "update and redirect when data is valid when logged in as that user",
    %{conn: conn, nonadmin_user: nonadmin_user}
  do
    conn = login_user(conn, nonadmin_user)
    conn = put(
      conn,
      user_path(conn, :update, nonadmin_user),
      user: @valid_create_attrs
    )
    assert redirected_to(conn) == user_path(conn, :show, nonadmin_user)
    assert Repo.get_by(User, @valid_attrs)
  end

  @tag :controller_user
  @tag :admin
  test "updates and redirects when data is valid when logged in as an admin",
    %{conn: conn, admin_user: admin_user}
  do
    conn = login_user(conn, admin_user)
    conn = put(
      conn,
      user_path(conn, :update, admin_user),
      user: @valid_create_attrs
    )
    assert redirected_to(conn) == user_path(conn, :show, admin_user)
    assert Repo.get_by(User, @valid_attrs)
  end

  @tag :controller_user
  @tag :admin
  test "does not update chosen resource when logged in as different user",
    %{conn: conn, nonadmin_user: nonadmin_user, admin_user: admin_user}
  do
    conn = login_user(conn, nonadmin_user)
    conn = put(
      conn,
      user_path(conn, :update, admin_user),
      user: @valid_create_attrs
    )
    flash = "You are not authorized to modify that user!"
    assert get_flash(conn, :error) == flash
    assert redirected_to(conn) == page_path(conn, :index)
    assert conn.halted
  end

  @tag :controller_user
  @tag :admin
  test "does not update and renders errors when data is invalid",
    %{conn: conn, nonadmin_user: nonadmin_user}
  do
    conn = login_user(conn, nonadmin_user)
    conn = put(
      conn,
      user_path(conn, :update, nonadmin_user),
      user: @invalid_attrs
    )
    assert html_response(conn, 200) =~ "Edit user"
  end

  @tag :controller_user
  @tag :admin
  test "deletes chosen resource when logged in as that user",
    %{conn: conn, some_user: some_user}
  do
    conn = conn
      |> login_user(some_user)
      |> delete(user_path(conn, :delete, some_user))
    assert redirected_to(conn) == user_path(conn, :index)
    refute Repo.get(User, some_user.id)
  end

  @tag :controller_user
  @tag :admin
  test "deletes chosen resource when logged in as an admin",
    %{conn: conn, some_user: some_user, admin_user: admin_user}
  do
    conn = conn
      |> login_user(admin_user)
      |> delete(user_path(conn, :delete, some_user))
    assert redirected_to(conn) == user_path(conn, :index)
    refute Repo.get(User, some_user.id)
  end

  @tag :controller_user
  @tag :admin
  test "redirects away from deleting when logged in as a different user",
     %{conn: conn, some_user: some_user, nonadmin_user: nonadmin_user}
  do
    conn = conn
      |> login_user(nonadmin_user)
      |> delete(user_path(conn, :delete, some_user))
    flash = "You are not authorized to modify that user!"
    assert get_flash(conn, :error) == flash
    assert redirected_to(conn) == page_path(conn, :index)
    assert conn.halted
  end

end
