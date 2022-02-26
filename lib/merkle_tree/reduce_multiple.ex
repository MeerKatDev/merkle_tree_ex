defmodule MerkleTree.ReduceMultiple do
  @moduledoc """
    Builds a new binary merkle tree.

    This version improves on the Basic one by traversing each level only once.
    The version with `++` was very slow, so I had to recurse to [hd | tl] appending + reverse().

    This copy works for non-binary trees.
  """
  require MerkleTree.Intermediate, as: Macrozz

  @hash_algorithm :sha256
  @children_num 4

  @spec get_root([String.t()]) :: String.t()
  def get_root([root]), do: root

  def get_root(nodes) do
    empty_lst = Enum.map(1..@children_num, fn _ -> nil end)
    Enum.reduce(nodes, {empty_lst, []}, Macrozz.intermediate_debug(empty_lst))
    |> then(fn
      {^empty_lst, hashes} ->
        hashes

      {[tx, nil, nil, nil], hashes} ->
        [sha256(Enum.map_join(1..@children_num, "", fn _ -> tx end)) | hashes]
    end)
    |> Enum.reverse()
    |> get_root()
  end

  @spec sha256(String.t()) :: String.t()
  def sha256(data) do
    @hash_algorithm
    |> :crypto.hash(data)
    |> Base.encode16(case: :lower)
  end

end
