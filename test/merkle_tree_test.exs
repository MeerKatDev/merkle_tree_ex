defmodule MerkleTreeTest do
  use ExUnit.Case
  doctest MerkleTree

  test "basic test" do
    hash = "12a40550c10c6339bf6f271445270e49b844d6c9e8abc36b9b642be532befe94"
    transactions = ["a", "b", "c", "d"]

    assert ^hash = MerkleTree.get_root(transactions)
    assert ^hash = MerkleTree.Reduce.get_root(transactions)
    assert ^hash = MerkleTree.ReduceNoInversion.get_root(transactions)
    assert ^hash = MerkleTree.ReduceMultiple.get_root(transactions)
  end

  test "small - 20 hashes" do
    hash = "8f7796cbcc4fe3791d9ffeb23e563756c3fe9eb5b6e986759a0945ef57b68c9b"
    transactions = File.read!("samples/input-20.txt") |> String.split("\n")

    assert ^hash = MerkleTree.get_root(transactions)
    assert ^hash = MerkleTree.Reduce.get_root(transactions)
    assert ^hash = MerkleTree.ReduceNoInversion.get_root(transactions)
    assert ^hash = MerkleTree.ReduceMultiple.get_root(transactions)
  end

  test "all given hashes" do
    hash = "402912cfd642e98eec5803488f4b47c2c7e88949b4f27845baf4bf7c0850edd5"
    transactions = File.read!("samples/input.txt") |> String.split("\n")

    assert ^hash = MerkleTree.get_root(transactions)
    assert ^hash = MerkleTree.Reduce.get_root(transactions)
    assert ^hash = MerkleTree.ReduceNoInversion.get_root(transactions)
  end
end
