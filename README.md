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

- 300x300, 248, 7
- 500x500, 408, 4
- 

# Commands
## Useful Commands for Running MLIR Code 
- /home/llvm-project/build/bin/mlir-opt matmul-tiling.mlir -split-input-file -affine-loop-tile="tile-size=32"
- /home/llvm-project/build/bin/mlir-opt matmul-tiling.mlir -split-input-file -affine-loop-tile="cache-size=512"

## Using the Makefile Pipeline 
- "make loop_tile_size" runs the affine dialect loop tile optimization from mlir to mlir
- "make convert_mlir_to_llvm" runs the entire pipeline for the affine loop optimization from mlir to llvm, outputting pipeline/convert_mlir_to_llvm.mlir which should only contain llvm instructions
- The make commands are intended to be run in your home directory on server and create a pipeline directory to store output
- You can run "make clean" to get rid of the pipeline directory and run it fresh
- "make get_executable" runs the MLIR conversion pipeline and also converts the output to llvm bc, makes an object file, and creates an executable from that
- "make run_cachegrind" runs the cachegrind command; it assumes the executable is called `basic_test.exe`
- "make tss" gives the executable `tss`. Then run `./tss <cache size> <cache line size> <number of rows> <number of columns>`
- For "make loop_tile_size" we should probably have a better way of specifying the tile size; currently it is hardcoded

## Parameters on the server
- Cache size: 64 KB (2048 elements if elements are 32 B) (use command `lscpu`)
- Cache line size: 64 B (2 elements if elements are 32 B) (use command `getconf LEVEL1_DCACHE_LINESIZE`)

## Cachegrind
- After running the "make convert_mlir_to_llvm" command, run `/home/llvm-project/build/bin/mlir-translate --mlir-to-llvmir ~/mlir-loop-tiling/pipeline/convert_mlir_to_llvm.mlir -o main_llvm.bc` to get the bitcode file
- Then run `llc -filetype=obj -opaque-pointers=1 main_llvm.bc` which should generate main_llvm.o
- Then run `gcc main_llvm.o -g -o basic_test.exe` 
- Last step is `valgrind --tool=cachegrind ./basic_test.exe`

# Results
- Output from cachegrind is stored in the results folder
- Output from running the tiling pass is stored in the tiled-matmul folder
- Default test cases are named by the dimensions of the matrix multiply _ default (square matrices are just named with a single number)
- TSS test cases for an (axb)*(bxc) matrix are named as follows
  - after TSS is run (by running `./tss 2048 2 b c), it outputs tile_rowsize and tile_colsize
  - input to tiling pass is a, tile-colsize, tile-rowsize (col comes before row because the for loop iterating over columns of the special matrix comes before the for loop iterating over rows)
  - test cases are named a_[tile-colsize]_[tile-rowsize]
  - sorry it is annoying to map a test case back to the original dimensions; this made sense as I was running the cases. You can figure it out by looking at the mlir file for that test case and seeing the parameters of the matrices

## Running a test case
Assume (axb)*(bxc) matrix multiply
1. Modify matmul-tiling.mlir
    1. arg0 should be of dimension axb, arg1 of dimension bxc, and arg2 of dimension axc
    2. i should go to a, j should go to c, and k should go to b
2. If running a TSS case:
    1. Run the tss algorithm with input 2048 2 b c (assuming the matrixes have 32B elements); get output tile-rowsize and tile-colsize.
    2. Modify TILE_SIZES in the Makefile to be a, tile-colsize, tile-rowsize.
3. Modify TEST_CASE in the Makefile to be the name of your test case.
4. Tile the matrix
    1. If default, run `make tile_default`.
    2. If TSS, run `make loop_tile_size`.
5. Run mlir code through pipeline to get executable: `make executable`
6. Profile with cachegrind to see number of cache misses: `make run_cachegrind`

## Notes
- Currently am running tss, then manually changing the Makefile tiling arguments. This could definitely be better.
- I also don't know how to get the cachegrind to send the output to a file (> doesn't seem to work) so am manually copying that. Should also be better.

# TODO
- Figure out how to add our pass to the rest of them
- Modify LoopTiling code and LoopUtils to support rectangular tiles
- Figure out what modifications to `getWorkingSetSize()` and `CIR()` are necessary with the current tiling pass
- Tiling for the most referenced matrix not all matrix [ideally but maybe too hard]


[1] getTileSizes(): How about just using `TSS.cpp` and set its resulting tilesize as `commend-line tileSize`?

```cpp
void LoopTiling::getTileSizes(ArrayRef<AffineForOp> band,
                              SmallVectorImpl<unsigned> *tileSizes) {
  if (band.empty())
    return;
 
  **// Use command-line tileSize for all loops if specified.**
  if (**tileSize**) {
    tileSizes->assign(band.size(), tileSize);
    return;
  }
```

[2] Should check if this func supports **rectangular** tile ??? Seems not yet supported 

1. [constructTiledLoopNest()](https://mlir.llvm.org/doxygen/LoopUtils_8cpp.html#a83637a522ca37f21ad29b95686634163)
2. tilePerfectlyNested()
3. separateFullTiles()
