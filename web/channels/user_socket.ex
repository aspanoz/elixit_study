defmodule AppPhoenix.UserSocket do
  @moduledoc '''
    UserSocket channel
  '''
  use Phoenix.Socket

  transport :websocket, Phoenix.Transports.WebSocket

  def connect(_params, socket) do
    {:ok, socket}
  end

  def id(_socket), do: nil
end
