defmodule MerkleTree do
  @moduledoc """
    Builds a new binary merkle tree.
  """
  @children_num 2
  @hash_algorithm :sha256

  @spec get_root([String.t()]) :: String.t()
  def get_root(transactions) do
    transactions
    |> build_tree()
  end

  # Base case
  defp build_tree([root]), do: root

  # Recursive case
  # each level is a recursion
  defp build_tree(nodes) do
    nodes
    |> Enum.chunk_every(@children_num)
    |> Enum.map(fn
      [l, r] -> sha256(l <> r)
      [x] -> sha256(x <> x)
    end)
    |> build_tree()
  end

  @spec sha256(String.t()) :: String.t()
  def sha256(data) do
    @hash_algorithm
    |> :crypto.hash(data)
    |> Base.encode16(case: :lower)
  end
end
