defmodule Hasher.Crypto do
  @moduledoc """
  Convert a block into a binary string and calculated the sha256 of it
  """

  @doc "Calculate hash of block"
  @spec encode(map) :: String.t
  def encode(block) do
    block
      |> Poison.encode!()
      |> sha256
  end

  # Calculate SHA256 for a binary string
  defp sha256(binary) do
    :crypto.hash(:sha256, binary)
      |> Base.encode16()
  end
end
