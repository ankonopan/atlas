defmodule Hasher.BlockHasher do

  def start(block) do
    {:ok, nonce_manager} = Hasher.NonceManager.start(block)
    GenServer.start(__MODULE__, nonce_manager)
  end

  def init(args) do
    {:ok, args}
  end

  def handle_call(:start, _, nonce_manager) do
    GenServer.call(nonce_manager, :run)
    {:reply, nil, nonce_manager}
  end

  def handle_call({:hash, hash}, _, nonce_manager) do
    IO.inspect("BlockHasher")
    IO.inspect(hash)
    {:reply, hash, nonce_manager}
  end
end
