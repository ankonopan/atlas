defmodule Blockchain do
  @doc """
  Makes available data type definitions and aliases to submodules that use this module.
  This is a convinient shorcut for having an uniform definition of types and having
  all the submodules aliases available by default.

  ## Example
    defmodule Channels.Model.DataType.NewType do
      use Channels.Model
    end
  """
  defmacro __using__(_params) do
    quote do
      alias Blockchain.DataType, as: Type

      @type block :: Type.Block
      @type chain :: Type.Chain
    end
  end
end
