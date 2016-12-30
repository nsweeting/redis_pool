defmodule RedisPool.Config do
  @doc """
  Retrieves a key value from the configuration.
  """
  def get(name, default \\ nil) do
    Application.get_env(:redis_connection_pool, name, default)
  end

  @doc """
  Retrieves the name of our Redis pool.
  """
  def pool_name, do: get(:pool_name, :"Redis.Pool")

  @doc """
  Retrieves the timeout for our connections.
  """
  def timeout, do: get(:timeout, 5000)
end