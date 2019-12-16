defmodule TimeMachinex.MixProject do
  use Mix.Project

  @version "0.3.0"
  @description "Time machine clock to simplify time testing"

  def project do
    [
      app: :time_machinex,
      version: @version,
      description: @description,
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),

      # Testing
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      dialyzer: [ignore_warnings: ".dialyzer", plt_add_deps: true],

      # Docs
      name: "TimeMachinex",
      docs: [extras: ["README.md", "CHANGELOG.md", "LICENSE.md"]]
    ]
  end

  defp package do
    [
      name: :time_machinex,
      files: [
        # Project files
        "mix.exs",
        "README.md",
        "CHANGELOG.md",
        "LICENSE.md",
        # TimeMachinex
        "lib/time_machinex.ex",
        "lib/time_machinex"
      ],
      maintainers: [
        "Antonio Sagliocco",
        "Elliott Hilaire",
        "Francesco Grammatico",
        "Ian Luites",
        "Ricardo Perez",
        "Tatsuya Ono"
      ],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/shinyscorpion/time_machinex"}
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:analyze, "~> 0.1", only: [:dev, :test], runtime: false},
      {:utc_datetime, ">= 0.0.0"}
    ]
  end
end
