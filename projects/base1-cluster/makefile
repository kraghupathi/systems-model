BUILD_DEST=build

all:  build

build: init
	emacs  --script elisp/publish.el
	rm -f ${BUILD_DEST}/docs/*.html~

init:
	mkdir -p ${BUILD_DEST}

export:
	rsync -auvz ${BUILD_DEST}/code ansible@10.4.14.101:/home/ansible/


clean:
	rm -rf ${BUILD_DEST}

