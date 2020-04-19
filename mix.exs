defmodule Defopaque.MixProject do
  use Mix.Project

  def project do
    [
      app: :defopaque,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      preferred_cli_env: [dialyzer: :test],
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
      {:dialyxir, "~> 0.5.1", only: :test, runtime: false},
    ]
  end
end
