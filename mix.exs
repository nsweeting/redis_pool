defmodule RedisPool.Mixfile do
  use Mix.Project

  def project do
    [app: :redis_connection_pool,
     version: "0.1.3",
     elixir: "~> 1.4-rc",
     description: description(),
     package: package(),
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [
      mod: {RedisPool, []},
      extra_applications: [:logger]
    ]
  end

  defp description do
    """
    Redis connection pool using Poolboy and Exredis.
    """
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*"],
      maintainers: ["Nicholas Sweeting"],
      licenses: ["MIT"],
      links: %{}
    ]
  end

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:poolboy, "~> 1.5.1"},
      {:exredis, ">= 0.2.4"},
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end
end
