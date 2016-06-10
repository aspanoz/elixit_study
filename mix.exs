defmodule AppPhoenix.Mixfile do
  use Mix.Project

  def project do
    [app: :app_phoenix,
      version: "0.0.1",
      elixir: "~> 1.0",
      elixirc_paths: elixirc_paths(Mix.env),
      compilers: [:phoenix, :gettext] ++ Mix.compilers,
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      aliases: aliases,
      deps: deps
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.

  def application do
    [
      mod: {AppPhoenix, []},
      applications: app_list(Mix.env)
    ]
  end

  defp app_list(:test), do: [:ex_machina | app_list]
  defp app_list(_), do: app_list
  defp app_list do
    [
      :phoenix,
      :phoenix_html,
      :cowboy,
      :logger,
      :gettext,
      :phoenix_ecto,
      :mariaex,
      :comeonin
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      # {:phoenix, "~> 1.1.4"},
      #{:phoenix_ecto, "~> 2.0"},
      {:phoenix, "~> 1.2.0-rc"},
      {:phoenix_pubsub, "~> 1.0.0-rc"},
      {:phoenix_ecto, "~> 3.0-rc"},

      {:phoenix_html, "~> 2.4"},
      {:gettext, "~> 0.9"},
      {:cowboy, "~> 1.0"},
      {:mariaex, ">= 0.0.0"}, # mysql client
      {:comeonin, "~> 2.4"},  # authorize
      {:earmark, "~> 0.2.1"}, # markdown?

      {:phoenix_live_reload, "~> 1.0", only: :dev},
      # {:ex_machina, "~> 0.6.1", only: :dev},
      {:ex_machina, "~> 1.0.0-beta.1", github: "thoughtbot/ex_machina"},
      {:dogma, "~> 0.1", only: :dev},
      {:credo, "~> 0.3", only: [:dev, :test]},
      {:wallaby, "~> 0.5.0", only: [:dev, :test], github: "keathley/wallaby"}
    ]
  end

  # Aliases are shortcut or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"]
    ]
  end
end
