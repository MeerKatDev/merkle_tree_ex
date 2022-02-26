Benchee.run(
  %{
    "Basic" => fn txs -> MerkleTree.get_root(txs) end,
    "Reduce" => fn txs -> MerkleTree.Reduce.get_root(txs) end,
    "ReduceNoInv" => fn txs -> MerkleTree.ReduceNoInversion.get_root(txs) end,
  },
  time: 10,
  memory_time: 5,
  warmup: 5,
  inputs: %{
    "Small" => ["a", "b", "c", "d"],
    "Medium" => File.read!("samples/input.txt") |> String.split("\n"),
    "Bigger" => File.read!("samples/input-100k.txt") |> String.split("\n")
  }
)