defmodule AppPhoenix.PostController do
  use AppPhoenix.Web, :controller

  alias AppPhoenix.Post
  alias AppPhoenix.User
  alias AppPhoenix.RoleChecker
  alias AppPhoenix.TextProcessor
  alias AppPhoenix.MyDebuger

  plug :scrub_params, "post" when action in [:create, :update]
  plug :assign_user
  plug :authorize_user when action in [:new, :create, :update, :edit, :delete]


    # Plug for nested resource (post under users) support user_post_path helper.
    # By using the assign function on our connection object,
    # we’ve exposed a variable that we can work with in our templates.
    # https://medium.com/@diamondgfx/writing-a-blog-engine-in-phoenix-part-2-authorization-814c06fa7c0#.9e50f4py1
  defp assign_user(conn, _opts) do
    case conn.params do
      %{"user_id" => user_id} ->
        case Repo.get(User, user_id) do
          nil  -> invalid_user(conn)
          user -> assign(conn, :user, user)
        end
      _ -> invalid_user(conn)
    end
  end

  defp invalid_user(conn) do
    conn
      |> put_flash(:error, "Invalid user!")
      |> redirect(to: page_path(conn, :index))
      |> halt
  end


    # Plug for access rights to CUD-action, action list in plug defenition
    # Only owner post user can do somethink with it
  defp authorize_user(conn, _) do
    user = get_session(conn, :current_user)
    # MyDebuger.echo(user, "User: ")
    if user && (Integer.to_string(user.id) == conn.params["user_id"] || RoleChecker.is_admin?(user)) do
      conn
    else
      conn
        |> put_flash(:error, "You are not authorized to modify that post!")
        |> redirect(to: page_path(conn, :index))
        |> halt()
    end
  end


  def index(conn, _params) do
    posts = Repo.all(assoc(conn.assigns[:user], :posts))
    render(conn, "index.html", posts: posts)
  end


  def new(conn, _params) do
    changeset =
      conn.assigns[:user]
        |> build_assoc(:posts)
        |> Post.changeset()
    render(conn, "new.html", changeset: changeset)
  end


  def create(conn, %{"post" => post_params}) do
    changeset =
      conn.assigns[:user]
        |> build_assoc(:posts)
        |> Post.changeset(post_params)
    case Repo.insert(changeset) do
      {:ok, _post} ->
        conn
          |> put_flash(:info, "Post created successfully.")
          |> redirect(to: user_post_path(conn, :index, conn.assigns[:user]))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end


  def show(conn, %{"id" => id}) do
    post = Repo.get!(assoc(conn.assigns[:user], :posts), id)
    conn
      |> assign(:parse_post, TextProcessor.parse_post(post.body))
      |> render("show.html", post: post)
  end


  def edit(conn, %{"id" => id}) do
    post = Repo.get!(assoc(conn.assigns[:user], :posts), id)
    changeset = Post.changeset(post)
    render(conn, "edit.html", post: post, changeset: changeset)
  end


  def update(conn, %{"id" => id, "post" => post_params}) do
    post = Repo.get!(assoc(conn.assigns[:user], :posts), id)
    changeset = Post.changeset(post, post_params)
    case Repo.update(changeset) do
      {:ok, post} ->
        conn
          |> put_flash(:info, "Post updated successfully.")
          |> redirect(to: user_post_path(conn, :show, conn.assigns[:user], post))
      {:error, changeset} ->
        render(conn, "edit.html", post: post, changeset: changeset)
    end
  end


  def delete(conn, %{"id" => id}) do
    post = Repo.get!(assoc(conn.assigns[:user], :posts), id)
    Repo.delete!(post)
    conn
      |> put_flash(:info, "Post deleted successfully.")
      |> redirect(to: user_post_path(conn, :index, conn.assigns[:user]))
  end

end
