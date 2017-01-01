defmodule RedisPool.Worker do
  use GenServer
  alias RedisPool.Config

  def start_link(_state) do
    GenServer.start_link(__MODULE__, [], [])
  end

  def init(_) do
    {:ok, %{conn: RedisPool.Client.new}}
  end

  def perform(call) do
    :poolboy.transaction(Config.pool_name(), fn(worker) ->
      GenServer.call(worker, call)
    end, Config.timeout())
  end

  @doc false
  def handle_call(%{command: command, params: params}, _from, %{conn: conn}) do
    conn = RedisPool.Client.ensure(conn)
    case command do
      :query ->
        {:reply, Exredis.query(conn, params), %{conn: conn}}
      :query_pipe ->
        {:reply, Exredis.query_pipe(conn, params), %{conn: conn}}
    end
  end
end