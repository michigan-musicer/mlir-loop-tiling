PATH_TO_BUILD = /home/llvm-project/build

PATH_TO_MLIR_SRC = /home/llvm-project/mlir

PATH_TO_TOY_EXAMPLE = $(PATH_TO_MLIR_SRC)/examples/toy

PATH_TO_TEST = $(PATH_TO_MLIR_SRC)/test

PATH_TO_EXAMPLES = ~/mlir-loop-tiling/examples

TEST_CASE = demo

TILE_SIZES = 100,10,184

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
	rm main_llvm.*
	rm basic_test.exe

init_pipeline: clean
	mkdir -p pipeline

loop_tile_size: init_pipeline
	$(PATH_TO_BUILD)/bin/mlir-opt $(PATH_TO_EXAMPLES)/matmul-tiling.mlir -split-input-file -affine-loop-tile="tile-sizes=$(TILE_SIZES)"> tiled-matmul/$(TEST_CASE).mlir

tile_default: init_pipeline
	$(PATH_TO_BUILD)/bin/mlir-opt $(PATH_TO_EXAMPLES)/matmul-tiling.mlir -split-input-file -affine-loop-tile="cache-size=64" > tiled-matmul/$(TEST_CASE).mlir

lower_affine: 
	$(PATH_TO_BUILD)/bin/mlir-opt tiled-matmul/$(TEST_CASE).mlir -lower-affine > pipeline/$@.mlir

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
	$(PATH_TO_BUILD)/bin/mlir-opt pipeline/convert_memref_to_llvm.mlir -reconcile-unrealized-casts > pipeline/$@.mlir

convert_to_bc: convert_mlir_to_llvm
	$(PATH_TO_BUILD)/bin/mlir-translate --mlir-to-llvmir pipeline/convert_mlir_to_llvm.mlir -o main_llvm.bc

executable: convert_to_bc
	llc -filetype=obj -opaque-pointers=1 main_llvm.bc
	gcc main_llvm.o -g -o basic_test.exe

run_cachegrind:
	valgrind --tool=cachegrind --log-file="results/$(TEST_CASE).txt" ./basic_test.exe

tss:
	g++ tss-demo/tss.cpp -o tss