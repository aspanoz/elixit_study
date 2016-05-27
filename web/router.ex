defmodule AppPhoenix.Router do
  @moduledoc '''
    web/router
  '''
  use AppPhoenix.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end


  pipeline :api do
    plug :accepts, ["json"]
  end


  scope "/", AppPhoenix do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    resources(
      "/sessions",
      SessionController,
      only: [:new, :create, :delete]
    )

    resources "/users", UserController do
      resources "/posts", PostController
    end

    resources "/posts", PostController, only: [] do
      resources(
        "/comments",
        CommentController,
        only: [:create, :delete, :update]
      )
    end

  end

end
