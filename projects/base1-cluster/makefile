BUILD_DEST=build

all:  build 

build: init
	emacs  --script elisp/publish.el
	rm -f ${DOCS_DEST}/*.html~

init:
	mkdir -p ${BUILD_DEST}

clean:
	rm -rf ${BUILD_DEST}

