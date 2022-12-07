module attributes {llvm.data_layout = ""} {
  llvm.func @simple_matmul(%arg0: !llvm.ptr<vector<64xf32>>, %arg1: !llvm.ptr<vector<64xf32>>, %arg2: i64, %arg3: i64, %arg4: i64, %arg5: i64, %arg6: i64, %arg7: !llvm.ptr<vector<64xf32>>, %arg8: !llvm.ptr<vector<64xf32>>, %arg9: i64, %arg10: i64, %arg11: i64, %arg12: i64, %arg13: i64, %arg14: !llvm.ptr<vector<64xf32>>, %arg15: !llvm.ptr<vector<64xf32>>, %arg16: i64, %arg17: i64, %arg18: i64, %arg19: i64, %arg20: i64) -> !llvm.struct<(ptr<vector<64xf32>>, ptr<vector<64xf32>>, i64, array<2 x i64>, array<2 x i64>)> {
    %0 = llvm.mlir.undef : !llvm.struct<(ptr<vector<64xf32>>, ptr<vector<64xf32>>, i64, array<2 x i64>, array<2 x i64>)>
    %1 = llvm.insertvalue %arg0, %0[0] : !llvm.struct<(ptr<vector<64xf32>>, ptr<vector<64xf32>>, i64, array<2 x i64>, array<2 x i64>)> 
    %2 = llvm.insertvalue %arg1, %1[1] : !llvm.struct<(ptr<vector<64xf32>>, ptr<vector<64xf32>>, i64, array<2 x i64>, array<2 x i64>)> 
    %3 = llvm.insertvalue %arg2, %2[2] : !llvm.struct<(ptr<vector<64xf32>>, ptr<vector<64xf32>>, i64, array<2 x i64>, array<2 x i64>)> 
    %4 = llvm.insertvalue %arg3, %3[3, 0] : !llvm.struct<(ptr<vector<64xf32>>, ptr<vector<64xf32>>, i64, array<2 x i64>, array<2 x i64>)> 
    %5 = llvm.insertvalue %arg5, %4[4, 0] : !llvm.struct<(ptr<vector<64xf32>>, ptr<vector<64xf32>>, i64, array<2 x i64>, array<2 x i64>)> 
    %6 = llvm.insertvalue %arg4, %5[3, 1] : !llvm.struct<(ptr<vector<64xf32>>, ptr<vector<64xf32>>, i64, array<2 x i64>, array<2 x i64>)> 
    %7 = llvm.insertvalue %arg6, %6[4, 1] : !llvm.struct<(ptr<vector<64xf32>>, ptr<vector<64xf32>>, i64, array<2 x i64>, array<2 x i64>)> 
    %8 = llvm.mlir.undef : !llvm.struct<(ptr<vector<64xf32>>, ptr<vector<64xf32>>, i64, array<2 x i64>, array<2 x i64>)>
    %9 = llvm.insertvalue %arg7, %8[0] : !llvm.struct<(ptr<vector<64xf32>>, ptr<vector<64xf32>>, i64, array<2 x i64>, array<2 x i64>)> 
    %10 = llvm.insertvalue %arg8, %9[1] : !llvm.struct<(ptr<vector<64xf32>>, ptr<vector<64xf32>>, i64, array<2 x i64>, array<2 x i64>)> 
    %11 = llvm.insertvalue %arg9, %10[2] : !llvm.struct<(ptr<vector<64xf32>>, ptr<vector<64xf32>>, i64, array<2 x i64>, array<2 x i64>)> 
    %12 = llvm.insertvalue %arg10, %11[3, 0] : !llvm.struct<(ptr<vector<64xf32>>, ptr<vector<64xf32>>, i64, array<2 x i64>, array<2 x i64>)> 
    %13 = llvm.insertvalue %arg12, %12[4, 0] : !llvm.struct<(ptr<vector<64xf32>>, ptr<vector<64xf32>>, i64, array<2 x i64>, array<2 x i64>)> 
    %14 = llvm.insertvalue %arg11, %13[3, 1] : !llvm.struct<(ptr<vector<64xf32>>, ptr<vector<64xf32>>, i64, array<2 x i64>, array<2 x i64>)> 
    %15 = llvm.insertvalue %arg13, %14[4, 1] : !llvm.struct<(ptr<vector<64xf32>>, ptr<vector<64xf32>>, i64, array<2 x i64>, array<2 x i64>)> 
    %16 = llvm.mlir.undef : !llvm.struct<(ptr<vector<64xf32>>, ptr<vector<64xf32>>, i64, array<2 x i64>, array<2 x i64>)>
    %17 = llvm.insertvalue %arg14, %16[0] : !llvm.struct<(ptr<vector<64xf32>>, ptr<vector<64xf32>>, i64, array<2 x i64>, array<2 x i64>)> 
    %18 = llvm.insertvalue %arg15, %17[1] : !llvm.struct<(ptr<vector<64xf32>>, ptr<vector<64xf32>>, i64, array<2 x i64>, array<2 x i64>)> 
    %19 = llvm.insertvalue %arg16, %18[2] : !llvm.struct<(ptr<vector<64xf32>>, ptr<vector<64xf32>>, i64, array<2 x i64>, array<2 x i64>)> 
    %20 = llvm.insertvalue %arg17, %19[3, 0] : !llvm.struct<(ptr<vector<64xf32>>, ptr<vector<64xf32>>, i64, array<2 x i64>, array<2 x i64>)> 
    %21 = llvm.insertvalue %arg19, %20[4, 0] : !llvm.struct<(ptr<vector<64xf32>>, ptr<vector<64xf32>>, i64, array<2 x i64>, array<2 x i64>)> 
    %22 = llvm.insertvalue %arg18, %21[3, 1] : !llvm.struct<(ptr<vector<64xf32>>, ptr<vector<64xf32>>, i64, array<2 x i64>, array<2 x i64>)> 
    %23 = llvm.insertvalue %arg20, %22[4, 1] : !llvm.struct<(ptr<vector<64xf32>>, ptr<vector<64xf32>>, i64, array<2 x i64>, array<2 x i64>)> 
    %24 = llvm.mlir.constant(0 : index) : i64
    %25 = llvm.mlir.constant(300 : index) : i64
    %26 = llvm.mlir.constant(32 : index) : i64
    llvm.br ^bb1(%24 : i64)
  ^bb1(%27: i64):  // 2 preds: ^bb0, ^bb17
    %28 = llvm.icmp "slt" %27, %25 : i64
    llvm.cond_br %28, ^bb2, ^bb18
  ^bb2:  // pred: ^bb1
    %29 = llvm.mlir.constant(0 : index) : i64
    %30 = llvm.mlir.constant(300 : index) : i64
    %31 = llvm.mlir.constant(32 : index) : i64
    llvm.br ^bb3(%29 : i64)
  ^bb3(%32: i64):  // 2 preds: ^bb2, ^bb16
    %33 = llvm.icmp "slt" %32, %30 : i64
    llvm.cond_br %33, ^bb4, ^bb17
  ^bb4:  // pred: ^bb3
    %34 = llvm.mlir.constant(0 : index) : i64
    %35 = llvm.mlir.constant(300 : index) : i64
    %36 = llvm.mlir.constant(32 : index) : i64
    llvm.br ^bb5(%34 : i64)
  ^bb5(%37: i64):  // 2 preds: ^bb4, ^bb15
    %38 = llvm.icmp "slt" %37, %35 : i64
    llvm.cond_br %38, ^bb6, ^bb16
  ^bb6:  // pred: ^bb5
    %39 = llvm.mlir.constant(32 : index) : i64
    %40 = llvm.add %27, %39  : i64
    %41 = llvm.mlir.constant(300 : index) : i64
    %42 = llvm.icmp "slt" %40, %41 : i64
    %43 = llvm.select %42, %40, %41 : i1, i64
    %44 = llvm.mlir.constant(1 : index) : i64
    llvm.br ^bb7(%27 : i64)
  ^bb7(%45: i64):  // 2 preds: ^bb6, ^bb14
    %46 = llvm.icmp "slt" %45, %43 : i64
    llvm.cond_br %46, ^bb8, ^bb15
  ^bb8:  // pred: ^bb7
    %47 = llvm.mlir.constant(32 : index) : i64
    %48 = llvm.add %32, %47  : i64
    %49 = llvm.mlir.constant(300 : index) : i64
    %50 = llvm.icmp "slt" %48, %49 : i64
    %51 = llvm.select %50, %48, %49 : i1, i64
    %52 = llvm.mlir.constant(1 : index) : i64
    llvm.br ^bb9(%32 : i64)
  ^bb9(%53: i64):  // 2 preds: ^bb8, ^bb13
    %54 = llvm.icmp "slt" %53, %51 : i64
    llvm.cond_br %54, ^bb10, ^bb14
  ^bb10:  // pred: ^bb9
    %55 = llvm.mlir.constant(32 : index) : i64
    %56 = llvm.add %37, %55  : i64
    %57 = llvm.mlir.constant(300 : index) : i64
    %58 = llvm.icmp "slt" %56, %57 : i64
    %59 = llvm.select %58, %56, %57 : i1, i64
    %60 = llvm.mlir.constant(1 : index) : i64
    llvm.br ^bb11(%37 : i64)
  ^bb11(%61: i64):  // 2 preds: ^bb10, ^bb12
    %62 = llvm.icmp "slt" %61, %59 : i64
    llvm.cond_br %62, ^bb12, ^bb13
  ^bb12:  // pred: ^bb11
    %63 = llvm.extractvalue %7[1] : !llvm.struct<(ptr<vector<64xf32>>, ptr<vector<64xf32>>, i64, array<2 x i64>, array<2 x i64>)> 
    %64 = llvm.mlir.constant(300 : index) : i64
    %65 = llvm.mul %45, %64  : i64
    %66 = llvm.add %65, %61  : i64
    %67 = llvm.getelementptr %63[%66] : (!llvm.ptr<vector<64xf32>>, i64) -> !llvm.ptr<vector<64xf32>>
    %68 = llvm.load %67 : !llvm.ptr<vector<64xf32>>
    %69 = llvm.extractvalue %15[1] : !llvm.struct<(ptr<vector<64xf32>>, ptr<vector<64xf32>>, i64, array<2 x i64>, array<2 x i64>)> 
    %70 = llvm.mlir.constant(300 : index) : i64
    %71 = llvm.mul %61, %70  : i64
    %72 = llvm.add %71, %53  : i64
    %73 = llvm.getelementptr %69[%72] : (!llvm.ptr<vector<64xf32>>, i64) -> !llvm.ptr<vector<64xf32>>
    %74 = llvm.load %73 : !llvm.ptr<vector<64xf32>>
    %75 = llvm.fmul %68, %74  : vector<64xf32>
    %76 = llvm.extractvalue %23[1] : !llvm.struct<(ptr<vector<64xf32>>, ptr<vector<64xf32>>, i64, array<2 x i64>, array<2 x i64>)> 
    %77 = llvm.mlir.constant(300 : index) : i64
    %78 = llvm.mul %45, %77  : i64
    %79 = llvm.add %78, %53  : i64
    %80 = llvm.getelementptr %76[%79] : (!llvm.ptr<vector<64xf32>>, i64) -> !llvm.ptr<vector<64xf32>>
    llvm.store %75, %80 : !llvm.ptr<vector<64xf32>>
    %81 = llvm.add %61, %60  : i64
    llvm.br ^bb11(%81 : i64)
  ^bb13:  // pred: ^bb11
    %82 = llvm.add %53, %52  : i64
    llvm.br ^bb9(%82 : i64)
  ^bb14:  // pred: ^bb9
    %83 = llvm.add %45, %44  : i64
    llvm.br ^bb7(%83 : i64)
  ^bb15:  // pred: ^bb7
    %84 = llvm.add %37, %36  : i64
    llvm.br ^bb5(%84 : i64)
  ^bb16:  // pred: ^bb5
    %85 = llvm.add %32, %31  : i64
    llvm.br ^bb3(%85 : i64)
  ^bb17:  // pred: ^bb3
    %86 = llvm.add %27, %26  : i64
    llvm.br ^bb1(%86 : i64)
  ^bb18:  // pred: ^bb1
    llvm.return %23 : !llvm.struct<(ptr<vector<64xf32>>, ptr<vector<64xf32>>, i64, array<2 x i64>, array<2 x i64>)>
  }
}

