BUILD_DEST=build
DOCS_DEST=docs

all:  build docs

build: init
	# TODO: explain below..
	# create necessary dirs..
	grep '^#.*:tangle' src/* 2>&1 | grep -v directory | sed 's/.*tangle //g' | sed 's/^..\///g' | grep -o '^[^ ]*' | grep -o '^.*/' | uniq | xargs echo
	grep '^#.*:tangle' src/* 2>&1 | grep -v directory | sed 's/.*tangle //g' | sed 's/^..\///g' | grep -o '^[^ ]*' | grep -o '^.*/' | uniq | xargs mkdir -p

docs: init
	emacs  --script elisp/publish.el
	rm -f ${DOCS_DEST}/*.html~

init:
	mkdir -p ${BUILD_DEST}
	mkdir -p ${DOCS_DEST}

clean:
	rm -rf ${BUILD_DEST}
	rm -rf ${DOCS_DEST}

