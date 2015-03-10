#This is just hacked to help in buliding files till a proper recursive makefile
#is built.  Run this using "make -f Makefile_hack"
all: build docs

build: build/site.yaml 

docs: docs/site.html

build/site.yaml: src/site.txt
	mkdir -p build
	emacs src/site.txt --batch -f org-mode -f org-babel-tangle --kill

docs/site.html: src/site.txt
	mkdir -p docs
	emacs src/site.txt --batch -f org-mode -f org-html-export-to-html --kill
	mv src/site.html docs/	
	rm -f src/site.html~

clean:
	rm -f src/*.html~


clean_all:
	rm -rf build
	mkdir -p build
	rm -rf docs
	mkdir -p docs
