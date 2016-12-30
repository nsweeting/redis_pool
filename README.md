# RedisPool

Redis connection pool using Poolboy and Exredis.

## Installation

Add the following to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:redis_connection_pool, "~> 0.1.3"}]
end
```

## Usage

```elixir
alias RedisPool, as: Redis

Redis.query(["SET", "key1", "value1"]) => {:ok, "OK"}
Redis.query(["GET", "key1"]) => {:ok, "value1"}
Redis.query(["GET", "key2"]) => {:undefined, nil}
```