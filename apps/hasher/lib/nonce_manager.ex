defmodule Hasher.NonceManager do
  use GenServer

  def start(block) do
    case Hasher.NonceIterator.start(block) do
      {:ok, name, nonce_iterator} ->
        GenServer.start(__MODULE__, {name, nonce_iterator, nil}, name: String.to_atom("manager_#{name}"))
      error ->
        {:error, error}
    end
  end

  def init(args) do
    {:ok, args}
  end

  def handle_call(:run, {block_hasher, _}, {name, nonce_iterator, _}) do
    for _ <- 1..Application.get_env(:hasher, :pool_size) do
      GenServer.call(nonce_iterator, :next)
    end
    {:reply, nil, {name, nonce_iterator, block_hasher}}
  end

  def handle_cast(hash, {name, nonce_iterator, block_hasher}) do
    if !is_valid?(hash) do
      if Process.alive?(nonce_iterator) do
        GenServer.call(nonce_iterator, :next)
      end
    else
      GenServer.stop(nonce_iterator)
      GenServer.call(block_hasher, {:hash, hash})
    end
    {:noreply, {name, nonce_iterator, block_hasher}}
  end

  def is_valid?(hash) do
    String.slice(hash, 0..3) == "0000"
  end
end
