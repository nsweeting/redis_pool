defmodule RedisPool.Worker do
  use GenServer

  def start_link(_state) do
    GenServer.start_link(__MODULE__, %{conn: nil}, [])
  end

  def init(state) do
    {:ok, state}
  end

  @doc false
  def handle_call(%{command: command, params: params}, _from, %{conn: nil}) do
    RedisPool.Client.new |> handle_command(command, params)
  end

  @doc false
  def handle_call(%{command: command, params: params}, _from, %{conn: conn}) do
    RedisPool.Client.ensure(conn) |> handle_command(command, params)
  end

  @doc false
  defp handle_command(conn, command, params) do
    case command do
      :query ->
        {:reply, Exredis.query(conn, params), %{conn: conn}}
      :query_pipe ->
        {:reply, Exredis.query_pipe(conn, params), %{conn: conn}}
    end
  end
end