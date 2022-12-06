# Current code

For now, I just have a row-major impl of TSS set up in `tss-demo/tss.cpp`. There are some issues that need to be fixed -- feel free to go in and fix them if you see them.

Run `g++ tss-demo/tss.cpp` and run `./a.out <cache_size> <cache_line_size> <row_length> <column_length>` to get the best row and column for a given set of parameters.

# Issues

- [DONE] uncertain if line 34 makes sense 
- [DONE] uncertain how to init `row_size` on line 48
    - we thought `cache_size % row_length` was fine, but this causes us never to enter the while loop if the cache is smaller than the array
- [DONE] current impl does not correctly handle working set size greater than cache

# Todos
- Create a pass in MLIR to apply TSS 
    - set up MLIR on server
    - copy over relevant parts of the MLIR loop tiling passes
    - get MLIR pass running successfully
    - change algorithm to use tss
    - decide which edge cases we don't want to handle  
    - do da coding
- [DONE] Fix case where you return cols_per_set + 1 (Minkyoung: no need to modify since it is correct)
- [DONE] Fix initialization of `row_size` (Minkyoung: check required)
- [DONE] Fix WS issue (Elanor)
- Write tests and walk through algorithm to determine correct solutions

# Test Cases
## Tests from Paper
- Cache sizes: 8K (512 element) and 64K (4096 element)
- Cache line sizes in bytes: 32 (2 element), 64 (4 element), 128 (8 element)
- Array sizes: 256 x 256, 300 x 300, 301 x 301

| CS  | CLS | Matrix    | Tile    | WS  | Pass? |
|-----|-----|-----------|---------|-----|-------|
| 512 | 2   | 300 x 300 | 16 x 29 | 482 | Y |
| 512 | 8   | 300 x 300 | 16 x 29 | Not given | Y | 
| 512 | 2   | 256 x 256 | 170 x 2 | 512 | Y |
| 512 | 2   | 301 x 301 | 28 x 17 | 506 | Y |
| 4096 | 8   | 256 x 256 | 240 x 16 | 4088 | Y |
| 4096 | 8   | 300 x 300 | 88 x 41 | 3704 | Y |
| 4096 | 8   | 301 x 301 | 112 x 26 | 3086 | Test invalid |

Note: Elanor and Minkyoung both think the last row dimensions are not possible given the algorithm

## Custom Cases
- 1024, 200, 200, 200 (PASS)
- 18, 8, 10, 10 
- 1024, ___, 200, 200
- cache smaller than array: 500 50 500000 100000 (PASS)
- WS never fits in cache: 256 8 240 240 (PASS)


## Useful Commands for Running MLIR Code 
- /home/llvm-project/build/bin/mlir-opt examples/matmul-tiling.mlir -split-input-file -affine-loop-tile="tile-size=32"
- /home/llvm-project/build/bin/mlir-opt examples/matmul-tiling.mlir -split-input-file -affine-loop-tile="cache-size=512"