defmodule RedisPool.Client do
  require Exredis
  alias RedisPool.Config

  @doc """
  Creates a new Redis client.
  """
  def new, do: build()

  @doc """
  Checks that a given client is alive, and if not, creates a new one.
  """
  def ensure(conn) do
    if Process.alive?(conn), do: conn, else: new()
  end

  @doc false
  def query(args) do
    RedisPool.Worker.perform(%{command: :query, params: args})
  end

  @doc false
  def query_pipe(args) do
    RedisPool.Worker.perform(%{command: :query_pipe, params: args})
  end

  @doc false
  defp build, do: build(Config.get(:full_url))

  @doc false
  defp build(nil) do
    host = Config.get(:host, "127.0.0.1")
    port = Config.get(:port, 6379)
    password = Config.get(:password, "")
    database = Config.get(:db, 0)
    reconnect = Config.get(:reconnect, :no_reconnect)
    {:ok, client} = Exredis.start_link(host, port, database, password, reconnect)
    client
  end

  @doc false
  defp build(full_url) when is_binary(full_url) do
    reconnect = Config.get(:reconnect, :no_reconnect)
    Exredis.start_using_connection_string(full_url, reconnect)
  end
end