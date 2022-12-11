#map = affine_map<(d0) -> (d0)>
#map1 = affine_map<(d0) -> (d0 + 800)>
#map2 = affine_map<(d0) -> (d0 + 96)>
#map3 = affine_map<(d0) -> (d0 + 41)>
#map4 = affine_map<(d0) -> (d0 + 96, 800)>
#map5 = affine_map<(d0) -> (d0 + 41, 800)>
#set = affine_set<(d0, d1) : (-d0 + 704 >= 0, -d1 + 759 >= 0)>
module {
  func.func @simple_matmul(%arg0: memref<800x800xvector<64xf32>>, %arg1: memref<800x800xvector<64xf32>>, %arg2: memref<800x800xvector<64xf32>>) -> memref<800x800xvector<64xf32>> {
    affine.for %arg3 = 0 to 800 step 800 {
      affine.for %arg4 = 0 to 800 step 96 {
        affine.for %arg5 = 0 to 800 step 41 {
          affine.if #set(%arg4, %arg5) {
            affine.for %arg6 = #map(%arg3) to #map1(%arg3) {
              affine.for %arg7 = #map(%arg4) to #map2(%arg4) {
                affine.for %arg8 = #map(%arg5) to #map3(%arg5) {
                  %0 = affine.load %arg0[%arg6, %arg7] : memref<800x800xvector<64xf32>>
                  %1 = affine.load %arg1[%arg7, %arg8] : memref<800x800xvector<64xf32>>
                  %2 = affine.load %arg2[%arg6, %arg8] : memref<800x800xvector<64xf32>>
                  %3 = arith.mulf %0, %1 : vector<64xf32>
                  %4 = arith.addf %2, %3 : vector<64xf32>
                  affine.store %3, %arg2[%arg6, %arg8] : memref<800x800xvector<64xf32>>
                }
              }
            }
          } else {
            affine.for %arg6 = #map(%arg3) to #map1(%arg3) {
              affine.for %arg7 = #map(%arg4) to min #map4(%arg4) {
                affine.for %arg8 = #map(%arg5) to min #map5(%arg5) {
                  %0 = affine.load %arg0[%arg6, %arg7] : memref<800x800xvector<64xf32>>
                  %1 = affine.load %arg1[%arg7, %arg8] : memref<800x800xvector<64xf32>>
                  %2 = affine.load %arg2[%arg6, %arg8] : memref<800x800xvector<64xf32>>
                  %3 = arith.mulf %0, %1 : vector<64xf32>
                  %4 = arith.addf %2, %3 : vector<64xf32>
                  affine.store %3, %arg2[%arg6, %arg8] : memref<800x800xvector<64xf32>>
                }
              }
            }
          }
        }
      }
    }
    return %arg2 : memref<800x800xvector<64xf32>>
  }
  func.func @main() {
    %alloc = memref.alloc() : memref<800x800xvector<64xf32>>
    %alloc_0 = memref.alloc() : memref<800x800xvector<64xf32>>
    %alloc_1 = memref.alloc() : memref<800x800xvector<64xf32>>
    %0 = call @simple_matmul(%alloc, %alloc_0, %alloc_1) : (memref<800x800xvector<64xf32>>, memref<800x800xvector<64xf32>>, memref<800x800xvector<64xf32>>) -> memref<800x800xvector<64xf32>>
    memref.dealloc %alloc : memref<800x800xvector<64xf32>>
    memref.dealloc %alloc_0 : memref<800x800xvector<64xf32>>
    memref.dealloc %alloc_1 : memref<800x800xvector<64xf32>>
    return
  }
}

