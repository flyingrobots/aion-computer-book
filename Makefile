TEX_MAIN := tex/computer.tex
BUILD_DIR := build
OUT_PDF := computer.pdf
TEX_SRCS := $(shell find tex -name '*.tex')

.PHONY: all clean

all: $(OUT_PDF)

$(BUILD_DIR)/computer.pdf: $(TEX_SRCS)
	mkdir -p $(BUILD_DIR)
	latexmk -pdf -interaction=nonstopmode -output-directory=$(BUILD_DIR) -auxdir=$(BUILD_DIR) $(TEX_MAIN)

$(OUT_PDF): $(BUILD_DIR)/computer.pdf
	cp $< $@

clean:
	latexmk -C -output-directory=$(BUILD_DIR) $(TEX_MAIN) || true
	rm -rf $(BUILD_DIR) $(OUT_PDF)
	rm -f tex/computer.{aux,log,out,fls,fdb_latexmk,synctex.gz,pdf}
