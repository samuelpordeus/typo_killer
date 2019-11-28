defmodule TypoKiller.MixProject do
  use Mix.Project

  def project do
    [
      app: :typo_killer,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:benchee, "~> 1.0", only: :dev}
    ]
  end
end
