PATH_TO_BUILD = /home/llvm-project/build

PATH_TO_MLIR_SRC = /home/llvm-project/mlir

PATH_TO_TOY_EXAMPLE = $(PATH_TO_MLIR_SRC)/examples/toy

PATH_TO_TEST = $(PATH_TO_MLIR_SRC)/test

PATH_TO_EXAMPLES = ~/mlir-loop-tiling/examples

init:
	mkdir -p out

ch1: init
	$(PATH_TO_BUILD)/bin/toyc-ch1 $(PATH_TO_TEST)/Examples/Toy/Ch1/ast.toy -emit=ast 2> out/$@.out

ch2: init
	$(PATH_TO_BUILD)/bin/toyc-ch2 $(PATH_TO_TEST)/Examples/Toy/Ch2/codegen.toy -emit=mlir -mlir-print-debuginfo 2> out/$@.out

ch2_tblgen: init
	$(PATH_TO_BUILD)/bin/mlir-tblgen -gen-op-defs  $(PATH_TO_TOY_EXAMPLE)/Ch2/include/toy/Ops.td -I $(PATH_TO_MLIR_SRC)/include/ > out/$@.out

ch5: init
	$(PATH_TO_BUILD)/bin/toyc-ch5 $(PATH_TO_TEST)/Examples/Toy/Ch5/affine-lowering.mlir -emit=mlir-affine -opt 2> out/$@.out

clean:
	rm -rf out
	rm -rf pipeline

init_pipeline:
	mkdir -p pipeline

loop_tile_size: init_pipeline
	$(PATH_TO_BUILD)/bin/mlir-opt $(PATH_TO_EXAMPLES)/matmul-tiling.mlir -split-input-file -affine-loop-tile="tile-size=32" > pipeline/$@.mlir

lower_affine: loop_tile_size
	$(PATH_TO_BUILD)/bin/mlir-opt pipeline/loop_tile_size.mlir -lower-affine > pipeline/$@.mlir

lower_affine: loop_tile_size
	$(PATH_TO_BUILD)/bin/mlir-opt pipeline/loop_tile_size.mlir -lower-affine > pipeline/$@.mlir

convert_scf_to_cf: lower_affine
	$(PATH_TO_BUILD)/bin/mlir-opt pipeline/lower_affine.mlir -convert-scf-to-cf > pipeline/$@.mlir

convert_cf_to_llvm: convert_scf_to_cf
	$(PATH_TO_BUILD)/bin/mlir-opt pipeline/convert_scf_to_cf.mlir -convert-cf-to-llvm > pipeline/$@.mlir

convert_func_to_llvm: convert_cf_to_llvm
	$(PATH_TO_BUILD)/bin/mlir-opt pipeline/convert_cf_to_llvm.mlir -convert-func-to-llvm > pipeline/$@.mlir

convert_arith_to_llvm: convert_func_to_llvm
	$(PATH_TO_BUILD)/bin/mlir-opt pipeline/convert_func_to_llvm.mlir -convert-arith-to-llvm > pipeline/$@.mlir

convert_memref_to_llvm: convert_arith_to_llvm
	$(PATH_TO_BUILD)/bin/mlir-opt pipeline/convert_arith_to_llvm.mlir -convert-memref-to-llvm > pipeline/$@.mlir

convert_mlir_to_llvm: convert_memref_to_llvm