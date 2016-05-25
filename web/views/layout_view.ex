defmodule AppPhoenix.LayoutView do
  @moduledoc '''
    web/views/layout_view
  '''
  use AppPhoenix.Web, :view

  def current_user(conn) do
    Plug.Conn.get_session(conn, :current_user)
  end

end
