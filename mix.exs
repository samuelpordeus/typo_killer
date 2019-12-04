defmodule TypoKiller.MixProject do
  use Mix.Project

  def project do
    [
      app: :typo_killer,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      dialyzer: [
        plt_add_deps: :transitive,
        plt_add_apps: [:mix],
        remove_defaults: [:unknown]
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
      {:dialyxir, "~> 0.5.1", only: :dev}
    ]
  end
end
