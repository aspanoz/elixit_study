defmodule AppPhoenix.Endpoint do
  @moduledoc '''
    Endpoint module
  '''
  use Phoenix.Endpoint, otp_app: :app_phoenix

  socket "/socket", AppPhoenix.UserSocket

  plug Plug.Static,
    at: "/", from: :app_phoenix, gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt)

  if Application.get_env(:app_phoenix, :sql_sandbox) do
    plug Phoenix.Ecto.SQL.Sandbox
  end

  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison

  plug Plug.MethodOverride
  plug Plug.Head

  plug Plug.Session,
    store: :cookie,
    key: "_app_phoenix_key",
    signing_salt: "9jeB1vBg"

  plug AppPhoenix.Router
end
