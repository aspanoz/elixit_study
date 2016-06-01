ExUnit.start

Mix.Task.run "ecto.create", ~w(-r AppPhoenix.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r AppPhoenix.Repo --quiet)
#Ecto.Adapters.SQL.begin_test_transaction(AppPhoenix.Repo)
Ecto.Adapters.SQL.Sandbox.mode(AppPhoenix.Repo, :manual)
Application.put_env(:wallaby, :base_url, AppPhoenix.Endpoint.url)

