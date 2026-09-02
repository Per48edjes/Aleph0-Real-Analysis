.PHONY: all clean purge release shell

NIX ?= nix
RESULT ?= result
PDF ?= main.pdf

all:
	$(NIX) build --out-link $(RESULT)
	rm -f $(PDF)
	ln -s $(RESULT)/main.pdf $(PDF)

shell:
	$(NIX) develop

clean:
	$(NIX) develop --command latexmk -C

purge: clean
	rm -f $(PDF) $(RESULT)

release: all
	./release.sh
