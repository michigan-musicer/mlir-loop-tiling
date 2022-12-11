#map = affine_map<(d0) -> (d0)>
#map1 = affine_map<(d0) -> (d0 + 2)>
module {
  func.func @simple_matmul(%arg0: memref<300x200xi32>, %arg1: memref<200x300xi32>, %arg2: memref<300x300xi32>) -> memref<300x300xi32> {
    affine.for %arg3 = 0 to 300 step 2 {
      affine.for %arg4 = 0 to 300 step 2 {
        affine.for %arg5 = 0 to 200 step 2 {
          affine.for %arg6 = #map(%arg3) to #map1(%arg3) {
            affine.for %arg7 = #map(%arg4) to #map1(%arg4) {
              affine.for %arg8 = #map(%arg5) to #map1(%arg5) {
                %0 = affine.load %arg0[%arg6, %arg8] : memref<300x200xi32>
                %1 = affine.load %arg1[%arg8, %arg7] : memref<200x300xi32>
                %2 = affine.load %arg2[%arg6, %arg7] : memref<300x300xi32>
                %3 = arith.muli %0, %1 : i32
                %4 = arith.addi %2, %3 : i32
                affine.store %3, %arg2[%arg6, %arg7] : memref<300x300xi32>
              }
            }
          }
        }
      }
    }
    return %arg2 : memref<300x300xi32>
  }
  func.func @main() {
    %alloc = memref.alloc() : memref<300x200xi32>
    %alloc_0 = memref.alloc() : memref<200x300xi32>
    %alloc_1 = memref.alloc() : memref<300x300xi32>
    %0 = call @simple_matmul(%alloc, %alloc_0, %alloc_1) : (memref<300x200xi32>, memref<200x300xi32>, memref<300x300xi32>) -> memref<300x300xi32>
    memref.dealloc %alloc : memref<300x200xi32>
    memref.dealloc %alloc_0 : memref<200x300xi32>
    memref.dealloc %alloc_1 : memref<300x300xi32>
    return
  }
}

