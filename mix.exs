defmodule Twitter.Mixfile do
  use Mix.Project

  def project do
    [app: :twitter,
     version: "0.0.1",
     elixir: "~> 1.0",
     escript: [main_module: Twitter],
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [{:paco, git: "https://github.com/gabrielelana/paco.git"}]
  end

  defp aliases do
    [start: ["compile", &Twitter.main/1]]
  end
end
