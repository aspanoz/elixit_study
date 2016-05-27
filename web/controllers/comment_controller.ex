defmodule AppPhoenix.CommentController do
  @moduledoc '''
    Comment controller
  '''
  use AppPhoenix.Web, :controller

  alias AppPhoenix.Comment
  alias AppPhoenix.Post

  plug :scrub_params, "comment" when action in [:create, :update]

  def create(conn, %{"comment" => comment_params, "post_id" => post_id}) do
    post = Post
      |> Repo.get!(post_id)
      |> Repo.preload([:user, :comments])
    changeset = post
      |> build_assoc(:comments)
      |> Comment.changeset(comment_params)

    case Repo.insert(changeset) do
      {:ok, _comment} ->
        conn
          |> put_flash(:info, "Comment created successfully!")
          |> redirect(to: user_post_path(conn, :show, post.user, post))
      {:error, changeset} ->
        render(
          conn,
          AppPhoenix.PostView,
          "show.html",
          post: post,
          user: post.user,
          comment_changeset: changeset
        )
    end
  end


  def update(
    conn,
    %{"id" => id, "post_id" => post_id, "comment" => comment_params}
  ) do
    post = Post
      |> Repo.get!(post_id)
      |> Repo.preload(:user)
    comment = Repo.get!(Comment, id)
    changeset = Comment.changeset(comment, comment_params)

    case Repo.update(changeset) do
      {:ok, _} ->
        conn
          |> put_flash(:info, "Comment updated successfully.")
          |> redirect(to: user_post_path(conn, :show, post.user, post))
      {:error, _} ->
        conn
          |> put_flash(:info, "Failed to update comment!")
          |> redirect(to: user_post_path(conn, :show, post.user, post))
    end
  end

  def delete(conn, %{"id" => id, "post_id" => post_id}) do
    post = Post
      |> Repo.get!(post_id)
      |> Repo.preload(:user)
    Comment
      |> Repo.get!(id)
      |> Repo.delete!
    conn
      |> put_flash(:info, "Deleted comment!")
      |> redirect(to: user_post_path(conn, :show, post.user, post))
  end

end
