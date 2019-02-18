defmodule VerySafeVeryShort.MixProject do
  use Mix.Project

  def project do
    [
      app: :very_safe_very_short,
      deps: deps(),
      elixir: "~> 1.7",
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      version: "0.1.0"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {VerySafeVeryShort.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 1.0"},
      {:excoveralls, "~> 0.10.5"},
      {:jason, "~> 1.1"},
      {:plug_cowboy, "~> 2.0.1"},
      {:redix, "~> 0.9.2"}
    ]
  end
end
