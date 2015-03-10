DEST=build/base1-cluster

all:  publish

publish: init
	emacs  --script elisp/publish.el

init:
	mkdir -p ${DEST}

clean:
	rm -rf ${DEST}

touch:
	find . -path '*/.svn' -prune -o -type f -exec touch "{}" \;
