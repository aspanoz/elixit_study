defmodule AppPhoenix.Router do
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

    resources "/posts", PostController
    resources "/users", UserController
    resources "/sessions", SessionController, only: [:new, :create, :delete]
  end

end
