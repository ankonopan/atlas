defmodule Hasher.NonceIterator do
  use GenServer

  def start(block) do
    hash = Hasher.Pool.encode(block, 0)
    case GenServer.start(__MODULE__, {block, 1}, name: String.to_atom(hash)) do
      {:ok, pid} ->
        {:ok, String.to_atom(hash), pid}
      {:error, {:already_started, pid}} ->
        {:ok, String.to_atom(hash), pid}
      response ->
        {:error, response}
    end
  end

  def init(args) do
    {:ok, args}
  end

  def handle_call(:next, {manager, _}, {block, nonce}) do
    if nonce < 4_294_967_295 do
      Task.start(fn ->
        hash = Hasher.Pool.encode(block, nonce)
        GenServer.cast(manager, hash)
      end)
    end
    {:reply, nil, {block, nonce + 1}}
  end
end
