defmodule ElixAtmo.MixProject do
  use Mix.Project

  def project do
    [
      app: :elixatmo,
      version: "0.3.0",
      elixir: "~> 1.11.0",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.7.0"},
      {:jason, "~> 1.2.2"},
      {:safeexstruct, git: "git://github.com/simoexpo/SafeExStruct.git", tag: "v0.4.0"},
      {:bypass, "~> 2.1.0", only: :test},
      {:mock, "~> 0.3.6", only: :test},
      {:excoveralls, "~> 0.13.3", only: :test}
    ]
  end
end
