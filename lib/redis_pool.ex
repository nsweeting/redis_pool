defmodule RedisPool do
  @moduledoc """
  Application that combines Poolboy and Exredis to provide a simple Redis
  connection pool.

  ## Example:
    ```elixir
    alias RedisPool, as: Redis

    Redis.query(["SET", "key1", "value1"]) => {:ok, "OK"}
    Redis.query(["GET", "key1"]) => {:ok, "value1"}
    Redis.query(["GET", "key2"]) => {:undefined, nil}
    ```
  """

  use Application
  alias RedisPool.Config

  @doc """
  Starts the RedisPool application.

  See http://elixir-lang.org/docs/stable/elixir/Application.html
  for more information on OTP Applications
  """
  def start(_type, _args) do
    pool_config = [
      name: {:local, Config.pool_name()},
      worker_module: RedisPool.Worker,
      size: Config.get(:pool_size, 10),
      max_overflow: Config.get(:pool_max_overflow, 1)
    ]

    RedisPool.Supervisor.start_link(pool_config)
  end

  @doc """
  Sends a query command to the Redis connection pool.
  """
  def query(args) when is_list(args) do
    args |> RedisPool.Client.query |> handle_result
  end

  @doc """
  Sends a pipelined query command to the Redis connection pool.
  """
  def query_pipe(args) when is_list(args) do
    args |> RedisPool.Client.query_pipe |> handle_result
  end

  defp handle_result([_, result]) when is_binary(result), do: {:ok, result}
  defp handle_result(:undefined), do: {:undefined, nil}
  defp handle_result(:error), do: {:error, nil}
  defp handle_result(result), do: {:ok, result}
end