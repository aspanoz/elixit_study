defmodule AppPhoenix.CommentControllerTest do
  use AppPhoenix.ConnCase

  alias AppPhoenix.Factory
  alias AppPhoenix.TextProcessor
  # alias AppPhoenix.MyDebuger

  @valid_attrs %{author: "Some Person", body: "This is a sample comment"}
  @invalid_attrs %{}

  setup do
    user = Factory.create(:user)
    post = Factory.create(:post, user: user)

    {:ok, conn: conn, user: user, post: post}
  end

  @tag :controller_comment
  test "creates resource and redirects when data is valid",
    %{conn: conn, post: post}
  do
    conn = post(
      conn,
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
end
