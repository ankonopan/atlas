defmodule Blockchain.DataType.Chain do
  alias __MODULE__
  use Blockchain

  @doc """
  Create a new blockchain with a zero block

   Examples 
    iex> [zero] = Blockchain.DataType.Chain.new
    iex> Blockchain.DataType.Block.valid?(zero)
    true
  """
  @spec new() :: list
  def new do
    [Crypto.put_hash(Type.Block.zero())]
  end

  @doc """
  Insert given data as a new block in the blockchain
  
  ## Examples 
    iex> chain = Blockchain.DataType.Chain.new
    iex> chain = Blockchain.DataType.Chain.insert(chain, "Hi there")
    iex> [first | [zero]] = chain
    iex> Blockchain.DataType.Block.valid?(first, zero)
    true
  """
  @spec insert(list, String.t) :: list
  def insert(blockchain, data) when is_list(blockchain) do
    %Type.Block{hash: prev} = hd(blockchain)
    [Type.Block.new(data, prev) | blockchain]
  end

  @doc """
  Validate the complete blockchain

  ## Examples 
    iex> chain = Blockchain.DataType.Chain.new
    iex> chain = Blockchain.DataType.Chain.insert(chain, "Hi there")
    iex> chain = Blockchain.DataType.Chain.insert(chain, "Hi those")
    iex> Blockchain.DataType.Chain.valid?(chain)
    true
  """
  @spec valid?(list) :: list
  def valid?(blockchain) when is_list(blockchain) do
    zero =
      Enum.reduce_while(blockchain, nil, fn prev, current ->
        cond do
          current == nil ->
            {:cont, prev}

          Type.Block.valid?(current, prev) ->
            {:cont, prev}

          true ->
            {:halt, false}
        end
      end)

    if zero, do: Type.Block.valid?(zero), else: false
  end
end
