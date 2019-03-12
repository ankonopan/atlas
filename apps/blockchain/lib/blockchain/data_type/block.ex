defmodule Blockchain.DataType.Block do
  alias __MODULE__
  use Blockchain

  defstruct([:data, :timestamp, :prev_hash, :hash, :nonce])
  @doc """
  Build a new block for given data and previous hash

  ## Examples
    iex> zero = Blockchain.DataType.Block.zero()
    iex> %{data: data_string, prev_hash: prev_hash_string} = Blockchain.DataType.Block.new("hi there", zero.hash)
    iex> data_string
    "hi there"
    iex> prev_hash_string
    zero.hash
  """
  @spec new(String.t, String.t) :: block
  def new(data, prev_hash) do
    b = %Block{
      data: data,
      prev_hash: prev_hash,
      timestamp: NaiveDateTime.utc_now()
    }
    %{b | hash: compute_hash(b)}
  end

  @doc """
  Build the initial block of the chain

  ## Examples
    iex> %{data: data_string, hash: hash_string} = Blockchain.DataType.Block.zero
    iex> data_string
    "ZERO_DATA"
    iex> hash_string
    "ZERO_HASH"
  """
  @spec zero() :: block
  def zero do
    %Block{
      data: "ZERO_DATA",
      hash: "ZERO_HASH",
      nonce: 1,
      prev_hash: nil,
      timestamp: NaiveDateTime.utc_now()
    }
  end

  @doc """
  Check if a block is valid

  ## Examples
    iex> zero = Blockchain.DataType.Block.zero()
    iex> first = Blockchain.DataType.Block.new("second", zero.hash)
    iex> Blockchain.DataType.Block.valid?(first)
    true
  """
  @spec valid?(block) :: boolean
  def valid?(%Block{} = block) do
    block
    |> block_core
    |> compute_hash
    |> (&(&1 === block.hash)).()
  end

  @doc """
  Validates that a block is the succesor of another block

  ## Examples
    iex> zero = Blockchain.DataType.Block.zero()
    iex> first = Blockchain.DataType.Block.new("second", zero.hash)
    iex> Blockchain.DataType.Block.valid?(first, zero)
    true
  """
  @spec valid?(block, block) :: boolean
  def valid?(%Block{} = block, %Block{} = prev_block) do
    block.prev_hash == prev_block.hash && valid?(block)
  end


  @spec block_core(block) :: %{}
  defp block_core(%Block{} = block) do
    block
    |> Map.take([:data, :prev_hash, :timestamp, :nonce])
  end

  # Proof of Work
  @spec compute_hash(block) :: String.t
  defp compute_hash(block) do
    "on development"
  end
end
