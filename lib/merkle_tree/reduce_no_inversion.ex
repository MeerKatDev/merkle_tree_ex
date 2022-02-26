defmodule MerkleTree.ReduceNoInversion do
  @moduledoc """
    Builds a new binary merkle tree.

    This version improves on Reduce by inverting every other level
    on the Merkel tree, removing the need to revert at the end.
  """
  @hash_algorithm :sha256

  # Base case
  @spec get_root([String.t()], boolean()) :: String.t()
  def get_root(_, inverted? \\ false)
  def get_root([root], _), do: root

  def get_root(nodes, inverted?) do
    init_tup = (inverted? && (rem(length(nodes), 2) != 0 && {hd(nodes), nil})) || {nil, nil}

    Enum.reduce(nodes, {init_tup, []}, fn
      tx, {{nil, nil}, hashes} ->
        {{tx, nil}, hashes}

      tx, {{l, nil}, hashes} ->
        {{l, tx}, hashes}

      tx, {{l, r}, hashes} ->
        {{tx, nil}, [sha256(l, r, inverted?) | hashes]}
    end)
    |> then(fn
      {{nil, nil}, hashes} ->
        hashes

      {{tx, nil}, hashes} ->
        [sha256(tx, tx, inverted?) | hashes]

      {{l, r}, hashes} ->
        [sha256(l, r, inverted?) | hashes]
    end)
    |> get_root(not inverted?)
  end

  @spec sha256(String.t(), String.t(), boolean()) :: String.t()
  defp sha256(l, r, true) do
    @hash_algorithm
    |> :crypto.hash(r <> l)
    |> Base.encode16(case: :lower)
  end

  defp sha256(l, r, false) do
    @hash_algorithm
    |> :crypto.hash(l <> r)
    |> Base.encode16(case: :lower)
  end
end
