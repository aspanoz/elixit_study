defmodule AppPhoenix.PostControllerTest do
  use AppPhoenix.ConnCase

  alias AppPhoenix.Post
  alias AppPhoenix.Factory

  @valid_attrs %{
    body: "some content",
    title: "some content"
  }
  @invalid_attrs %{}

  setup do
    role = Factory.insert(:role)
    user = Factory.insert(:user, role: role)
    other_user = Factory.insert(:user, role: role)
    admin = Factory.insert(:user, role: Factory.insert(:role, admin: true))
    post = Factory.insert(:post, user: user)
    conn = build_conn() |> login_user(user)

    {
      :ok,
      conn: conn,
      user: user,
      post: post,
      admin: admin,
      other_user: other_user
    }
  end

  defp login_user(conn, user) do
    post(
      conn,
      session_path(conn, :create),
      user: %{username: user.username, password: user.password}
    )
  end

  defp logout_user(conn, user) do
    delete conn, session_path(conn, :delete, user)
  end

  defp build_post(user) do
    changeset = user
      |> build_assoc(:posts)
      |> Post.changeset(@valid_attrs)
    Repo.insert!(changeset)
  end

  @tag :controller_post
  test "lists all entries on index", %{conn: conn, user: user} do
    conn = get conn, user_post_path(conn, :index, user)
    assert html_response(conn, 200) =~ "Listing posts"
  end

  @tag :controller_post
  test "renders form for new resources",
    %{conn: conn, user: user}
  do
    conn = get conn, user_post_path(conn, :new, user)
    assert html_response(conn, 200) =~ "New post"
  end

  @tag :controller_post
  test "creates resource and redirects when data is valid",
    %{conn: conn, user: user}
  do
    conn = post(
      conn,
      user_post_path(conn, :create, user),
      post: @valid_attrs
    )
    assert redirected_to(conn) == user_post_path(conn, :index, user)
    assert Repo.get_by(assoc(user, :posts), @valid_attrs)
  end


  @tag :controller_post
  test "does not create resource and renders errors when data is invalid",
    %{conn: conn, user: user}
  do
    conn = post(
      conn,
      user_post_path(conn, :create, user),
      post: @invalid_attrs
    )
    assert html_response(conn, 200) =~ "New post"
  end


  @tag :controller_post
  test "when logged in as the author, shows with author flag set to true",
    %{conn: conn, user: user}
  do
    post = build_post(user)
    conn = conn
      |> login_user(user)
      |> get(user_post_path(conn, :show, user, post))
    assert html_response(conn, 200) =~ "Show post"
    assert conn.assigns[:author_or_admin]
  end

  @tag :controller_post
  test "when logged in as an admin, shows with author flag set to true",
    %{conn: conn, user: user, admin: admin}
  do
    post = build_post(user)
    conn = conn
      |> login_user(admin)
      |> get(user_post_path(conn, :show, user, post))
    assert html_response(conn, 200) =~ "Show post"
    assert conn.assigns[:author_or_admin]
  end

  @tag :controller_post
  test "when not logged in, shows with author flag set to false",
    %{conn: conn, user: user}
  do
    post = build_post(user)
    conn = conn
      |> logout_user(user)
      |> get(user_post_path(conn, :show, user, post))
    assert html_response(conn, 200) =~ "Show post"
    refute conn.assigns[:author_or_admin]
  end

  @tag :controller_post
  test "when logged in as a other user, shows with author flag set to false",
    %{conn: conn, user: user, other_user: other_user}
  do
    post = build_post(user)
    conn = conn
      |> login_user(other_user)
      |> get(user_post_path(conn, :show, user, post))
    assert html_response(conn, 200) =~ "Show post"
    refute conn.assigns[:author_or_admin]
  end


  @tag :controller_post
  test "renders page not found when id is nonexistent",
    %{conn: conn, user: user}
  do
    assert_error_sent 404, fn ->
      get conn, user_post_path(conn, :show, user, -1)
    end
  end


  @tag :controller_post
  test "renders form for editing chosen resource",
    %{conn: conn, user: user, post: post}
  do
    conn = get conn, user_post_path(conn, :edit, user, post)
    assert html_response(conn, 200) =~ "Edit post"
  end


  @tag :controller_post
  test "updates chosen resource and redirects when data is valid",
    %{conn: conn, user: user, post: post}
  do
    conn = put(
      conn,
      user_post_path(conn, :update, user, post),
      post: @valid_attrs
    )
    assert redirected_to(conn) == user_post_path(conn, :show, user, post)
    assert Repo.get_by(Post, @valid_attrs)
  end


  @tag :controller_post
  test "does not update and renders errors when data is invalid",
    %{conn: conn, user: user, post: post}
  do
    conn = put(
      conn,
      user_post_path(conn, :update, user, post),
      post: %{"body" => nil}
    )
    assert html_response(conn, 200) =~ "Edit post"
  end


  @tag :controller_post
  test "deletes chosen resource", %{conn: conn, user: user, post: post} do
    conn = delete conn, user_post_path(conn, :delete, user, post)
    assert redirected_to(conn) == user_post_path(conn, :index, user)
    refute Repo.get(Post, post.id)
  end


  @tag :controller_post
  test "redirects when the specified user does not exist", %{conn: conn} do
    conn = get conn, user_post_path(conn, :index, -1)
    assert get_flash(conn, :error) == "Invalid user!"
    assert redirected_to(conn) == page_path(conn, :index)
    assert conn.halted
  end


  @tag :controller_post
  test "redirects when trying to edit a post for a different user",
    %{conn: conn, post: post, other_user: other_user}
  do
    conn = get conn, user_post_path(conn, :edit, other_user, post)
    flash = "You are not authorized to modify that post!"
    assert get_flash(conn, :error) == flash
    assert redirected_to(conn) == page_path(conn, :index)
    assert conn.halted
  end


  @tag :controller_post
  test "redirects when trying to update a post for a different user",
    %{conn: conn, post: post, other_user: other_user}
  do
    conn = put(
      conn,
      user_post_path(conn, :update, other_user, post),
      %{"post" => @valid_attrs}
    )
    flash = "You are not authorized to modify that post!"
    assert get_flash(conn, :error) == flash
    assert redirected_to(conn) == page_path(conn, :index)
    assert conn.halted
  end

  @tag :controller_post
  test "redirects when trying to delete a post for a different user",
    %{conn: conn, post: post, other_user: other_user}
  do
    conn = delete conn, user_post_path(conn, :delete, other_user, post)
    flash = "You are not authorized to modify that post!"
    assert get_flash(conn, :error) == flash
    assert redirected_to(conn) == page_path(conn, :index)
    assert conn.halted
  end

  @tag :controller_post
  test "renders form for editing chosen resource when logged in as admin",
    %{conn: conn, user: user, post: post, admin: admin}
  do
    conn = conn
      |> login_user(admin)
      |> get(user_post_path(conn, :edit, user, post))
    assert html_response(conn, 200) =~ "Edit post"
  end

  @tag :controller_post
  test "updates and redirects when data is valid when logged in as admin",
    %{conn: conn, user: user, post: post, admin: admin}
  do
    conn = conn
      |> login_user(admin)
      |> put(user_post_path(conn, :update, user, post), post: @valid_attrs)
    assert redirected_to(conn) == user_post_path(conn, :show, user, post)
    assert Repo.get_by(Post, @valid_attrs)
  end

  @tag :controller_post
  test "not update and renders errors when data is invalid when admin",
    %{conn: conn, user: user, post: post, admin: admin}
  do
    conn = conn
      |> login_user(admin)
      |> put(
        user_post_path(conn, :update, user, post),
        post: %{"body" => nil}
      )
    assert html_response(conn, 200) =~ "Edit post"
  end

  @tag :controller_post
  test "deletes chosen resource when logged in as admin",
    %{conn: conn, user: user, post: post, admin: admin}
  do
    conn = conn
      |> login_user(admin)
      |> delete(user_post_path(conn, :delete, user, post))
    assert redirected_to(conn) == user_post_path(conn, :index, user)
    refute Repo.get(Post, post.id)
  end

end
