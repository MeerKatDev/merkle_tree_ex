defmodule MerkleTree.Reduce do
  @moduledoc """
    Builds a new binary merkle tree.

    This version improves on the Basic one by traversing each level only once.
    The version with `++` was very slow, so I had to recurse to [hd | tl] appending + reverse().
  """
  @hash_algorithm :sha256

  @spec get_root([String.t()]) :: String.t()
  def get_root([root]), do: root

  def get_root(nodes) do
    Enum.reduce(nodes, {{nil, nil}, []}, fn
      tx, {{nil, nil}, hashes} ->
        {{tx, nil}, hashes}

      tx, {{l, nil}, hashes} ->
        {{l, tx}, hashes}

      tx, {{l, r}, hashes} ->
        {{tx, nil}, [sha256(l <> r) | hashes]}
    end)
    # after
    |> then(fn
      {{nil, nil}, hashes} ->
        hashes

      {{tx, nil}, hashes} ->
        [sha256(tx <> tx) | hashes]

      {{l, r}, hashes} ->
        [sha256(l <> r) | hashes]

      x ->
        IO.inspect(x)
        raise "WTF"
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
