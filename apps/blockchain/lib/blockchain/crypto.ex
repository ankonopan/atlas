defmodule Blockchain.Crypto do
  alias __MODULE__
  use Blockchain

  @doc """
  Convert a block into a binary string and calculated the sha256 of it
  """
  # Specify which fields to hash in a block
  @hash_fields [:data, :timestamp, :prev_hash]

  @doc "Calculate hash of block"
  @spec hash(block) :: String.t
  def hash(%{} = block) do
    block
    |> Map.take(@hash_fields)
    |> Poison.encode!()
    |> sha256
  end

  @doc "Calculate and put the hash in the block"
  def put_hash(%{} = block) do
    %{block | hash: hash(block)}
  end

  # Calculate SHA256 for a binary string
  defp sha256(binary) do
    :crypto.hash(:sha256, binary) |> Base.encode16()
  end
end
