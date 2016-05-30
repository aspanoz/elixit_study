defmodule AppPhoenix.LayoutView do
  @moduledoc '''
    web/views/layout_view
  '''
  use AppPhoenix.Web, :view
  import Plug.Conn, only: [get_session: 2]

  def current_user(conn) do
    get_session(conn, :current_user)
  end

end
