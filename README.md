# MerkleTree

Disclaimer: the cloning could be a bit slower because of the samples/input-100k.txt file.

Implementation of a Merkle tree as a test assignment.
The tree is assumed binary.
The input is assumed already hashed, so there was no need to rehash the first level.
I took the output of the basic version as correct (the `hash` in each test).
There is a benchmarking comparison between three different versions with three different input sizes.
Here are the results on my machine:

```
% mix run benchmarks/main.exs
Operating System: macOS
CPU Information: Intel(R) Core(TM) i7-4770HQ CPU @ 2.20GHz
Number of Available Cores: 8
Available memory: 16 GB
Elixir 1.13.1
Erlang 24.2

Benchmark suite executing with the following configuration:
warmup: 5 s
time: 10 s
memory time: 5 s
parallel: 1
inputs: Bigger, Medium, Small
Estimated total run time: 3 min

Benchmarking Basic with input Bigger...
Benchmarking Basic with input Medium...
Benchmarking Basic with input Small...
Benchmarking Reduce with input Bigger...
Benchmarking Reduce with input Medium...
Benchmarking Reduce with input Small...
Benchmarking ReduceNoInv with input Bigger...
Benchmarking ReduceNoInv with input Medium...
Benchmarking ReduceNoInv with input Small...

##### With input Bigger #####
Name                  ips        average  deviation         median         99th %
Reduce              0.200         5.00 s    ±11.37%         5.00 s         5.41 s
ReduceNoInv         0.172         5.83 s     ±1.04%         5.83 s         5.87 s
Basic               0.166         6.01 s     ±1.43%         6.01 s         6.07 s

Comparison:
Reduce              0.200
ReduceNoInv         0.172 - 1.17x slower +0.83 s
Basic               0.166 - 1.20x slower +1.00 s

Memory usage statistics:

Name           Memory usage
Reduce            651.04 MB
ReduceNoInv       629.43 MB - 0.97x memory usage -21.61264 MB
Basic             914.20 MB - 1.40x memory usage +263.16 MB

**All measurements for memory usage were the same**

##### With input Medium #####
Name                  ips        average  deviation         median         99th %
ReduceNoInv          9.18      108.88 ms    ±16.77%      117.60 ms      156.99 ms
Reduce               8.48      117.96 ms     8.65%      115.61 ms      179.02 ms
Basic                8.27      120.88 ms    ±25.67%      116.78 ms      183.45 ms

Comparison:
ReduceNoInv          9.18
Reduce               8.48 - 1.08x slower +9.08 ms
Basic                8.27 - 1.11x slower +12.00 ms

Memory usage statistics:

Name           Memory usage
ReduceNoInv         6.88 MB
Reduce              7.13 MB - 1.04x memory usage +0.25 MB
Basic               9.99 MB - 1.45x memory usage +3.11 MB

**All measurements for memory usage were the same**

##### With input Small #####
Name                  ips        average  deviation         median         99th %
Reduce           142.53 K        7.02 μs  ±1671.21%        5.90 μs       15.90 μs
ReduceNoInv      133.12 K        7.51 μs  ±1426.68%        5.90 μs       15.90 μs
Basic            122.71 K        8.15 μs  ±1482.95%        6.90 μs       16.90 μs

Comparison:
Reduce           142.53 K
ReduceNoInv      133.12 K - 1.07x slower +0.50 μs
Basic            122.71 K - 1.16x slower +1.13 μs

Memory usage statistics:

Name           Memory usage
Reduce              1.44 KB
ReduceNoInv         1.47 KB - 1.02x memory usage +0.0313 KB
Basic               2.59 KB - 1.80x memory usage +1.15 KB

**All measurements for memory usage were the same**
```
which are kind of interesting: in general looks like the `Reduce` version is better, but for certain intermediate input sizes, `ReduceNoInv` is slightly better. That could be up to some OS characteristics I suppose, and type of memory allocation.

## Opportunities for improvement

I thought at more ways to improve the algorithm

 - Streams: I couldn't find a way to use them recursively, that would be a good improvement for memory usage, which could be huge for large inputs. For example, one million hashes takes up some GB, which could be prohibitive on some machines.
 - Concurrency: I thought at a way to, figuratively, create processes which could "go up the tree" and each computing one branch in each level. For each level, we would have half of the processes active. I guess another way, which could be in practice more performant (create thousands of process could effectively make no difference), would be to divide big inputs in 2, 4, 8 parts and then manually join them, depending on the magnitude of inputs.
