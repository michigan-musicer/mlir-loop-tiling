# Current code

For now, I just have a row-major impl of TSS set up in `tss-demo/tss.cpp`. There are some issues that need to be fixed -- feel free to go in and fix them if you see them.

Run `g++ tss-demo/tss.cpp` and run `./a.out <cache_size> <cache_line_size> <row_length> <column_length>` to get the best row and column for a given set of parameters.

# Issues

- uncertain if line 34 makes sense
- uncertain how to init `row_size` on line
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