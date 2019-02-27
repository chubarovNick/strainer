defmodule Strainer.MixProject do
  use Mix.Project

  def project do
    [
      app: :strainer,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      elixirc_paths: elixirc_paths(Mix.env()),
      package: package(),
      deps: deps(),
      aliases: aliases(),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.travis": :test,
        "coveralls.html": :test
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [applications: applications(Mix.env())]
  end

  defp applications(:test), do: applications() ++ ~w(postgrex ecto )a
  defp applications(_), do: applications()
  defp applications(), do: ~w(logger)a

  defp elixirc_paths(:test), do: elixirc_paths() ++ ~w(test/support)
  defp elixirc_paths(_), do: elixirc_paths()
  defp elixirc_paths(), do: ~w(lib)

  defp package do
    [
      name: :filterable,
      files: ["lib", "mix.exs", "README*", "config"],
      maintainers: ["Nick Chubarov"],
      licenses: ["MIT"],
    ]
  end

  defp aliases do
    [
      "ecto.seed": "run priv/repo/seeds.exs",
      "ecto.setup": ["ecto.create", "ecto.migrate"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.19", only: [:dev, :docs]},
      {:credo, "~> 0.10.2", only: [:dev, :test]},
      {:excoveralls, "~> 0.10", only: :test},
      {:postgrex, ">= 0.0.0", only: :test},
      {:ex_machina, "~> 2.2", only: [:dev, :test]},
      {:ecto, "~> 2.2", only: [:dev, :test]}
    ]
  end
end
