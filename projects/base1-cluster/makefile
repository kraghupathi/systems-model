DEST=build

all:  build docs

build: init
	mkdir -p ${DEST}/scripts
	echo "building scripts.."

docs: init
	emacs  --script elisp/publish.el
	rm -f ${DEST}/docs/*.html~

init:
	mkdir -p ${DEST}

clean:
	rm -rf ${DEST}

touch:
	find . -path '*/.svn' -prune -o -type f -exec touch "{}" \;
