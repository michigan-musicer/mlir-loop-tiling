# Current code

For now, I just have a row-major impl of TSS set up in `tss-demo/tss.cpp`. There are some issues that need to be fixed -- feel free to go in and fix them if you see them.

Run `g++ tss-demo/tss.cpp` and run `./a.out <cache_size> <cache_line_size> <row_length> <column_length>` to get the best row and column for a given set of parameters.

# Issues

- uncertain if line 34 makes sense
- uncertain how to init `row_size` on line 48
    - we thought `cache_size % row_length` was fine, but this causes us never to enter the while loop if the cache is smaller than the array
- current impl does not correctly handle working set size greater than cache

# Todos
- figure out what "adjust best col to meet working set size constraint" is in tss.cpp
    - probably related to previous issue?
- Create a pass in MLIR to apply TSS 
    - set up MLIR on server
    - copy over relevant parts of the MLIR loop tiling passes
    - get MLIR pass running successfully
    - change algorithm to use tss
    - decide which edge cases we don't want to handle  
    - do da coding
- Fix case where you return cols_per_set + 1 (bc probably correct as is) (Minkyoung)
- [DONE] Fix initialization of `row_size` (Minkyoung)
- Fix WS issue (Elanor)
- Write tests and walk through algorithm to determine correct solutions

# Test Cases
- 1024, ___, 200, 200
- 8K, 32, 300, 300
- paper has 8K (512 element) and 64K (4096 element) cache size
- paper has cache line size 32 (2 element), 64 (4 element), 128 (8 element) (bytes)
- array size generally 300 x 300, it's 303 x 21 for liv23
- array sizes 256 x 256, 300 x 300, 301 x 301
- cache smaller than array
- WS never fits in cache
