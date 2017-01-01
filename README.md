# RedisPool

Redis connection pool using Poolboy and Exredis.

## Installation

Add the following to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:redis_connection_pool, "~> 0.1.4"}]
end
```

## Setup

Add the following to your list of applications in `mix.exs`.

```elixir
def application do
  # Specify extra applications you'll use from Erlang/Elixir
  [extra_applications: [:redis_connection_pool]]
end
```

Add the following to your configuration in `config/confix.exs`.

```elixir
config :redis_connection_pool, [
  host: "127.0.0.1",
  port: 6379,
  password: "",
  db: 0,
  reconnect: :no_reconnect,
  pool_name: :"Redis.Pool",
  pool_size: 10,
  pool_max_overflow: 1
]
```

## Usage

```elixir
alias RedisPool, as: Redis

Redis.query(["SET", "key1", "value1"]) => {:ok, "OK"}
Redis.query(["GET", "key1"]) => {:ok, "value1"}
Redis.query(["GET", "key2"]) => {:undefined, nil}
```