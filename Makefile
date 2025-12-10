TEX_MAIN := tex/computer.tex
BUILD_DIR := build
OUT_PDF := computer.pdf
TEX_SRCS := $(shell find tex -name '*.tex')
SVG_SRCS := $(wildcard svg/*.svg)
SVG_PDFS := $(SVG_SRCS:.svg=.pdf)

.PHONY: all clean

all: $(OUT_PDF)

$(BUILD_DIR)/computer.pdf: $(TEX_SRCS) $(SVG_PDFS)
	mkdir -p $(BUILD_DIR)
	latexmk -pdf -interaction=nonstopmode -output-directory=$(BUILD_DIR) -auxdir=$(BUILD_DIR) $(TEX_MAIN)

$(OUT_PDF): $(BUILD_DIR)/computer.pdf
	cp $< $@

# Ensure every svg has a matching pdf (needed by pdflatex includegraphics)
svg/%.pdf: svg/%.svg
	@if command -v inkscape >/dev/null 2>&1; then \
	  inkscape --export-type=pdf --export-filename=$@ $<; status=$$?; \
	else \
	  status=127; \
	fi; \
	if [ $$status -ne 0 ]; then \
	  if command -v rsvg-convert >/dev/null 2>&1; then \
	    rsvg-convert -f pdf -o $@ $< || { echo \"Error: rsvg-convert failed for $<\" >&2; exit 1; }; \
	  else \
	    echo \"Error: need inkscape or rsvg-convert to convert $< to $@\" >&2; exit 1; \
	  fi; \
	fi

clean:
	latexmk -C -output-directory=$(BUILD_DIR) $(TEX_MAIN) || true
	rm -rf $(BUILD_DIR) $(OUT_PDF)
	rm -f tex/computer.{aux,log,out,fls,fdb_latexmk,synctex.gz,pdf}
