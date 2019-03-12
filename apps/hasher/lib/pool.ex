defmodule Hasher.Pool do
  use Application

  @pool_name Application.get_env(:hasher, :pool_name)
  @pool_size Application.get_env(:hasher, :pool_size)
  @timeout 1_000

  def start(_type, _args) do
    children = [
      :poolboy.child_spec(@pool_name, poolboy_config(@pool_name, @pool_size))
    ]

    opts = [strategy: :one_for_one, name: Hasher.Pool]
    Supervisor.start_link(children, opts)
  end

  def status do
    :poolboy.status(@pool_name)
  end

  def encode(block, nonce) do
    :poolboy.transaction(
        @pool_name,
        fn pid ->
          GenServer.call(pid, Map.put(block, :nonce, nonce))
        end,
        @timeout
    )
  end


  defp poolboy_config(pool_name, pool_size) do
    [
      {:name, {:local, pool_name}},
      {:worker_module, Hasher.Worker},
      {:size, pool_size},
      {:max_overflow, round(pool_size * 0.2)}
    ]
  end
end
