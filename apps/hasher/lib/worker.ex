defmodule Hasher.Worker do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil)
  end

  def init(_) do
    {:ok, nil}
  end

  def handle_call(block, _, state) do
    {:reply, Hasher.Crypto.encode(block), state}
  end
end
