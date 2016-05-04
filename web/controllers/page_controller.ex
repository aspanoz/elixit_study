defmodule AppPhoenix.PageController do
  use AppPhoenix.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
