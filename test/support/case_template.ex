defmodule AppPhoenix.AcceptanceCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Wallaby.DSL

      import Ecto.Model
      import Ecto.Query, only: [from: 2]
      import AppPhoenix.Router.Helpers

      def login(session, user) do
        session
        |> visit("/sessions/new")
        |> find("#login-form")
        |> fill_in("user_username", with: user.username)
        |> fill_in("user_password", with: user.password)
        |> click_on("Submit")
        session
      end

      def logout(session) do
        session
        |> visit("/")
        |> click_link("Log out")
        session
      end
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(AppPhoenix.Repo)
    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(AppPhoenix.Repo, {:shared, self()})
    end

    metadata = Phoenix.Ecto.SQL.Sandbox.metadata_for(AppPhoenix.Repo, self())

    {:ok, session} = Wallaby.start_session(metadata: metadata)
    {:ok, session: session}
  end
end
