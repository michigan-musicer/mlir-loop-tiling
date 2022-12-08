// TODO: Write mlir code for paper example 


// Toy 1
// | CS  | CLS | Matrix    | Tile    | WS  |
// |-----|-----|-----------|---------|-----|
// | 512 | 2   | 300 x 300 | 16 x 29 | 482 |

func.func @simple_matmul(%arg0: memref<300x300xvector<64xf32>>, %arg1: memref<300x300xvector<64xf32>>, %arg2: memref<300x300xvector<64xf32>>) -> memref<300x300xvector<64xf32>> {
  affine.for %i = 0 to 300 {
    affine.for %j = 0 to 300 {
      affine.for %k = 0 to 300 {
        %l = affine.load %arg0[%i, %k] : memref<300x300xvector<64xf32>>
        %r = affine.load %arg1[%k, %j] : memref<300x300xvector<64xf32>>
        %m = arith.mulf %l, %r : vector<64xf32>
        affine.store %m, %arg2[%i, %j] : memref<300x300xvector<64xf32>>
      }
    }
  }
  return %arg2 : memref<300x300xvector<64xf32>>
}

func.func @main() {
  %A0 = memref.alloc() : memref<300x300xvector<64xf32>>
  %A1 = memref.alloc() : memref<300x300xvector<64xf32>>
  %A2 = memref.alloc() : memref<300x300xvector<64xf32>>
  %r = call @simple_matmul(%A0, %A1, %A2) : (memref<300x300xvector<64xf32>>, memref<300x300xvector<64xf32>>, memref<300x300xvector<64xf32>>) -> memref<300x300xvector<64xf32>>
  memref.dealloc %A0 : memref<300x300xvector<64xf32>>
  memref.dealloc %A1 : memref<300x300xvector<64xf32>>
  memref.dealloc %A2 : memref<300x300xvector<64xf32>>
  return
}
// Toy 2: X + Y * Z
// Cache size is set to 512 KiB. This loop nest accesses about 49 MiB, and the
// tile sizes chosen would be 6 x 6 x 6. However, to avoid min/max, which is
// possible here, they are adjusted to 4 x 4 x 5.
