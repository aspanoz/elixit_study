defmodule AppPhoenix.CommentControllerTest do
  use AppPhoenix.ConnCase

  alias AppPhoenix.Factory
  alias AppPhoenix.Comment
  alias AppPhoenix.TextProcessor
  # alias AppPhoenix.MyDebuger

  @valid_attrs %{author: "Some Person", body: "This is a sample comment"}
  @invalid_attrs %{}

  setup do
    user = Factory.create(:user)
    post = Factory.create(:post, user: user)
    comment = Factory.create(:comment, post: post)

    {:ok, conn: conn, user: user, post: post, comment: comment}
  end

  defp login_user(conn, user) do
    conn
      |> post(
        session_path(conn, :create),
        user: %{username: user.username, password: user.password}
      )
  end

  @tag :controller_comment
  test "creates resource and redirects when data is valid",
    %{conn: conn, post: post}
  do
    conn = conn
      |> post(
        post_comment_path(conn, :create, post),
        comment: @valid_attrs
      )
    assert redirected_to(conn) == user_post_path(conn, :show, post.user, post)
    assert Repo.get_by(assoc(post, :comments), @valid_attrs)
  end

  @tag :controller_comment
  test "does not create resource and renders errors when data is invalid",
    %{conn: conn, post: post}
  do
    conn = conn
      |> assign(:parse_post, TextProcessor.parse_post(post.body))
      |> post(post_comment_path(conn, :create, post), comment: @invalid_attrs)
    assert html_response(conn, 200) =~ "Oops, something went wrong"
  end


  @tag :controller_comment
  test "deletes the comment when logged in as an authorized user",
    %{conn: conn, user: user, post: post, comment: comment}
  do
    conn = conn
      |> login_user(user)
      |> delete(post_comment_path(conn, :delete, post, comment))
    assert redirected_to(conn) == user_post_path(conn, :show, post.user, post)
    refute Repo.get(Comment, comment.id)
  end

  @tag :controller_comment
  test "does not delete the comment when not logged in as an authorized user",
    %{conn: conn, post: post, comment: comment}
  do
    conn = conn
      |> delete(post_comment_path(conn, :delete, post, comment))
    assert redirected_to(conn) == page_path(conn, :index)
    assert Repo.get(Comment, comment.id)
  end

  @tag :controller_comment
  test "updates and redirects when data is valid and logged in as the author",
    %{conn: conn, user: user, post: post, comment: comment}
  do
    conn = conn
      |> login_user(user)
      |> put(
        post_comment_path(conn, :update, post, comment),
        comment: %{"approved" => true}
      )
    assert redirected_to(conn) == user_post_path(conn, :show, user, post)
    assert Repo.get_by(Comment, %{id: comment.id, approved: true})
  end

  @tag :controller_comment
  test "does not update the comment when not logged in as an authorized user",
    %{conn: conn, post: post, comment: comment}
  do
    conn = conn
      |> put(
        post_comment_path(conn, :update, post, comment),
        comment: %{"approved" => true}
      )
    assert redirected_to(conn) == page_path(conn, :index)
    refute Repo.get_by(Comment, %{id: comment.id, approved: true})
  end

end
