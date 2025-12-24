SHELL := /bin/bash

TEX_MAIN := tex/computer.tex
BUILD_DIR := build
OUT_PDF := computer.pdf
TEX_SRCS := $(shell find tex -name '*.tex')
SVG_SRCS := $(wildcard svg/*.svg)
SVG_PDFS := $(SVG_SRCS:.svg=.pdf)

# Force a UTF-8 locale so latexmk/perl doesn't choke on unavailable defaults
LATEX_ENV := LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 LC_CTYPE=en_US.UTF-8

.PHONY: all clean
.PHONY: progress
.PHONY: pdf

all: $(OUT_PDF)

$(BUILD_DIR)/computer.pdf: $(TEX_SRCS) $(SVG_PDFS)
	mkdir -p $(BUILD_DIR)
	$(LATEX_ENV) latexmk -pdf -interaction=nonstopmode -output-directory=$(BUILD_DIR) -auxdir=$(BUILD_DIR) $(TEX_MAIN)

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
	$(LATEX_ENV) latexmk -C -output-directory=$(BUILD_DIR) $(TEX_MAIN) || true
	rm -rf $(BUILD_DIR) $(OUT_PDF)
	rm -f tex/computer.{aux,log,out,fls,fdb_latexmk,synctex.gz,pdf}

progress:
	@set -e; \
	  file="ROADMAP.md"; \
	  done=$$(grep -ao "✅" "$$file" | wc -l | tr -d " "); \
	  doing=$$(grep -ao "⏳" "$$file" | wc -l | tr -d " "); \
	  todo=$$(grep -ao "◽️" "$$file" | wc -l | tr -d " "); \
	  total=$$((done + doing + todo)); \
	  if [ $$total -eq 0 ]; then pct=0; else pct=$$(((100*done + total/2)/total)); fi; \
	  width=20; filled=$$(((pct*width + 50)/100)); \
	  bar_short="["; for ((i=1;i<=width;i++)); do if [ $$i -le $$filled ]; then bar_short="$${bar_short}█"; else bar_short="$${bar_short}░"; fi; done; bar_short="$${bar_short}]"; \
	  width2=49; filled2=$$(((pct*width2 + 50)/100)); \
	  bar_long="["; for ((i=1;i<=width2;i++)); do if [ $$i -le $$filled2 ]; then bar_long="$${bar_long}█"; else bar_long="$${bar_long}░"; fi; done; bar_long="$${bar_long}]"; \
	  bottom="0   10   20   30   40   50   60   70   80   90  100"; \
	  for f in ROADMAP.md README.md; do \
	    [ -f "$$f" ] || continue; \
	    PROGPCT="$${pct}% ($${done}/$${total})" perl -0777 -CS -Mutf8 -pi -e 'my $$r=$$ENV{PROGPCT}; s|<!-- PROGRESS_PCT(?:_README)? -->.*?<!-- /PROGRESS_PCT(?:_README)? -->|<!-- PROGRESS_PCT -->$$r<!-- /PROGRESS_PCT -->|sg' "$$f"; \
	    PROGBAR_SHORT="$${bar_short}" perl -0777 -CS -Mutf8 -pi -e 'my $$r=$$ENV{PROGBAR_SHORT}; s|<!-- PROGRESS_BAR(?:_README)? -->.*?<!-- /PROGRESS_BAR(?:_README)? -->|<!-- PROGRESS_BAR -->$$r<!-- /PROGRESS_BAR -->|sg' "$$f"; \
	    PROGBAR_LONG="$${bar_long}" BOTTOM="$${bottom}" perl -0777 -CS -Mutf8 -pi -e 'my ($$r,$$b)=@ENV{qw/PROGBAR_LONG BOTTOM/}; s|(<!-- progress -->\n```text\n)[^\n]*\n[^\n]*\n(```\n<!-- /progress -->)|$$1$$r\n$$b\n$$2|sg' "$$f"; \
	  done; \
	  echo "Updated progress to $${pct}% ($${done}/$${total}) across ROADMAP.md and README.md"

# Build a single chapter as a standalone PDF into ./adhoc/
# Examples:
#   make pdf tex/06-ch-04.tex
#   make pdf 06-ch-04.tex
#   make pdf CHAPTER=tex/06-ch-04.tex
pdf:
	@chapter="$(or $(CHAPTER),$(filter-out $@,$(MAKECMDGOALS)))"; \
	  if [ -z "$$chapter" ]; then \
	    echo "Usage: make pdf tex/06-ch-04.tex  (or: make pdf 06-ch-04.tex)"; \
	    exit 2; \
	  fi; \
	  python3 scripts/chapter-pdf "$$chapter"

# Allow `make pdf 06-ch-04.tex` without requiring the file to exist at repo root.
%.tex:
	@:
