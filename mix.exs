defmodule TypoKiller.MixProject do
  use Mix.Project

  @version "0.1.0"
  @repo "https://github.com/samuelpordeus/typo_killer"

  def project do
    [
      app: :typo_killer,
      version: @version,
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      dialyzer: [
        plt_add_deps: :transitive,
        plt_add_apps: [:mix],
        remove_defaults: [:unknown]
      ],
      name: "Typo Killer",
      source_url: @repo,
      docs: [
        main: "TypoKiller",
        extras: ["README.md"]
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:benchee, "~> 1.0", only: :dev},
      {:dialyxir, "~> 0.5.1", only: :dev, runtime: false},
      {:ex_doc, "~> 0.21", only: :dev, runtime: false},
    ]
  end
end
