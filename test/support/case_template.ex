defmodule AppPhoenix.AcceptanceCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Wallaby.DSL

      import Ecto.Model
      import Ecto.Query, only: [from: 2]
      import AppPhoenix.Router.Helpers
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
