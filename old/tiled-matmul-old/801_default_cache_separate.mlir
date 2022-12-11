#map = affine_map<(d0) -> (d0)>
#map1 = affine_map<(d0) -> (d0 + 3)>
#set = affine_set<() : (0 == 0)>
module {
  func.func @simple_matmul(%arg0: memref<801x801xvector<64xf32>>, %arg1: memref<801x801xvector<64xf32>>, %arg2: memref<801x801xvector<64xf32>>) -> memref<801x801xvector<64xf32>> {
    affine.for %arg3 = 0 to 801 step 3 {
      affine.for %arg4 = 0 to 801 step 3 {
        affine.for %arg5 = 0 to 801 step 3 {
          affine.if #set() {
            affine.for %arg6 = #map(%arg3) to #map1(%arg3) {
              affine.for %arg7 = #map(%arg4) to #map1(%arg4) {
                affine.for %arg8 = #map(%arg5) to #map1(%arg5) {
                  %0 = affine.load %arg0[%arg6, %arg8] : memref<801x801xvector<64xf32>>
                  %1 = affine.load %arg1[%arg8, %arg7] : memref<801x801xvector<64xf32>>
                  %2 = arith.mulf %0, %1 : vector<64xf32>
                  affine.store %2, %arg2[%arg6, %arg7] : memref<801x801xvector<64xf32>>
                }
              }
            }
          } else {
            affine.for %arg6 = #map(%arg3) to #map1(%arg3) {
              affine.for %arg7 = #map(%arg4) to #map1(%arg4) {
                affine.for %arg8 = #map(%arg5) to #map1(%arg5) {
                  %0 = affine.load %arg0[%arg6, %arg8] : memref<801x801xvector<64xf32>>
                  %1 = affine.load %arg1[%arg8, %arg7] : memref<801x801xvector<64xf32>>
                  %2 = arith.mulf %0, %1 : vector<64xf32>
                  affine.store %2, %arg2[%arg6, %arg7] : memref<801x801xvector<64xf32>>
                }
              }
            }
          }
        }
      }
    }
    return %arg2 : memref<801x801xvector<64xf32>>
  }
  func.func @main() {
    %alloc = memref.alloc() : memref<801x801xvector<64xf32>>
    %alloc_0 = memref.alloc() : memref<801x801xvector<64xf32>>
    %alloc_1 = memref.alloc() : memref<801x801xvector<64xf32>>
    %0 = call @simple_matmul(%alloc, %alloc_0, %alloc_1) : (memref<801x801xvector<64xf32>>, memref<801x801xvector<64xf32>>, memref<801x801xvector<64xf32>>) -> memref<801x801xvector<64xf32>>
    memref.dealloc %alloc : memref<801x801xvector<64xf32>>
    memref.dealloc %alloc_0 : memref<801x801xvector<64xf32>>
    memref.dealloc %alloc_1 : memref<801x801xvector<64xf32>>
    return
  }
}

