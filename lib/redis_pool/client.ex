defmodule RedisPool.Client do
  require Exredis
  alias RedisPool.Config

  @doc """
  Creates a new Redis client.
  """
  def new do
    {:ok, client} = build()
    client
  end

  @doc """
  Checks that a given client is alive, and if not, creates a new one.
  """
  def ensure(conn) do
    if Process.alive?(conn), do: conn, else: new()
  end

  @doc false
  def query(args), do: command(args, :query)

  @doc false
  def query_pipe(args), do: command(args, :query_pipe)

  @doc false
  defp command(args, type) do
    :poolboy.transaction(Config.pool_name(), fn(worker) ->
      GenServer.call(worker, %{command: type, params: args})
    end, Config.timeout())
  end

  @doc false
  defp build do
    host = Config.get(:host, "127.0.0.1")
    port = Config.get(:port, 6379)
    password = Config.get(:password, "")
    database = Config.get(:db, 0)
    reconnect = Config.get(:reconnect, :no_reconnect)
    Exredis.start_link(host, port, database, password, reconnect)
  end
end