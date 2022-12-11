// TODO: Write mlir code for paper example 


// Toy 1
// | CS  | CLS | Matrix    | Tile    | WS  |
// |-----|-----|-----------|---------|-----|
// | 512 | 2   | 800 x 800 | 16 x 29 | 482 |

func.func @simple_matmul(%arg0: memref<100x200xi32>, %arg1: memref<200x300xi32>, %arg2: memref<100x300xi32>) -> memref<100x300xi32> {
  affine.for %i = 0 to 100 {
    affine.for %j = 0 to 300 {
      affine.for %k = 0 to 200 {
        %l = affine.load %arg0[%i, %k] : memref<100x200xi32>
        %r = affine.load %arg1[%k, %j] : memref<200x300xi32>
        %o = affine.load %arg2[%i, %j] : memref<100x300xi32>
        %m = arith.muli %l, %r : i32
        %a = arith.addi %o, %m : i32
        affine.store %m, %arg2[%i, %j] : memref<100x300xi32>
      }
    }
  }
  return %arg2 : memref<100x300xi32>
}

func.func @main() {
  %arg0 = memref.alloc() : memref<100x200xi32>
  %arg1 = memref.alloc() : memref<200x300xi32>
  %arg2 = memref.alloc() : memref<100x300xi32>
  %r = call @simple_matmul(%arg0, %arg1, %arg2) : (memref<100x200xi32>, memref<200x300xi32>, memref<100x300xi32>) -> memref<100x300xi32>
  memref.dealloc %arg0 : memref<100x200xi32>
  memref.dealloc %arg1 : memref<200x300xi32>
  memref.dealloc %arg2 : memref<100x300xi32>
  return
}
// Toy 2: X + Y * Z
// Cache size is set to 512 KiB. This loop nest accesses about 49 MiB, and the
// tile sizes chosen would be 6 x 6 x 6. However, to avoid min/max, which is
// possible here, they are adjusted to 4 x 4 x 5.
