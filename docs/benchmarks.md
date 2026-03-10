# benchmarks

Input data of different sizes were tested.
Jobs with over 250gb of memory usage were killed during error correction, due to current resource constraints on the used cluster.
Benchmark values will be updated, should the issue be solved in the future.

## values for the m-hpc (current version):

| seq data (gb) | convert CPUs (count)| convert mem (gb) | convert time (h:m:s) | basecall GPUs  (count)| basecall CPUs  (count)| basecall mem (gb) | basecall time (h:m:s) | correct GPUs  (count)| correct CPUs  (count)| correct mem (gb) | correct time (h:m:s) | comment |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 81  | 1.56 | 2.33 | 00:31:08 | 4 | 5.08 | 74.95 | 01:31:10 | 4 | 71.18 | 123.55 | 02:38:32 | - |
| 199 | 1.61 | 2.22 | 01:17:27 | 4 | 5.27 | 164.63 | 03:27:04 | 4 | 85.77 | 227.59 | 09:33:25 | - |
| 258 | 1.56 | 2.47 | 01:28:38 | 4 | 5.00 | 183.65 | 04:33:07 | 4 | n/a | > 250 | OOM | correction killed |
| 325 | 1.54 | 2.52 | 01:50:35 | 4 | 5.00 | 235.34 | 05:43:22 | 4 | n/a | > 250 | OOM | correction killed |
| 346 | 1.75 | 2.05 | 02:19:27 | 4 | 5.58 | 234.23 | 05:50:42 | 4 | n/a | > 250 | OOM | correction killed |
| 410 | 1.56 | 2.52 | 02:16:08 | 4 | 4.99 | 209.33 | 07:14:32 | 4 | n/a | > 250 | OOM | correction killed |
