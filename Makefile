PATH_TO_BUILD = /home/llvm-project/build

PATH_TO_MLIR_SRC = /home/llvm-project/mlir

PATH_TO_TOY_EXAMPLE = $(PATH_TO_MLIR_SRC)/examples/toy

PATH_TO_TEST = $(PATH_TO_MLIR_SRC)/test

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