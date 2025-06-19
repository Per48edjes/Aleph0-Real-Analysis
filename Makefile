.PHONY: all clean purge release

all:
	./build.sh

clean:
	latexmk -C

purge: clean
	rm -f main.pdf

release: all
	./release.sh
