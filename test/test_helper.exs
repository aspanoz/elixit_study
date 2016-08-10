{:ok, _} = Application.ensure_all_started(:wallaby)
ExUnit.start

Mix.Task.run "ecto.reset", ~w(-r AppPhoenix.Repo --quiet)

Ecto.Adapters.SQL.Sandbox.mode(AppPhoenix.Repo, :manual)
Application.put_env(:app_phoenix, :sql_sandbox, true)

Application.put_env(:wallaby, :base_url, AppPhoenix.Endpoint.url)
Application.put_env(:wallaby, :screenshot_on_failure, true)
