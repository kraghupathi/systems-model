BUILD_DEST=build

all:  build

build: init
	emacs  --script elisp/publish.el
	rm -f ${BUILD_DEST}/docs/*.html~

init:
	mkdir -p ${BUILD_DEST}

clean:
	rm -rf ${BUILD_DEST}

