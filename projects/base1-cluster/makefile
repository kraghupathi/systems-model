BUILD_DEST=build

all:  build

build: init
	emacs  --script elisp/publish.el
	rm -f ${BUILD_DEST}/docs/*.html~

init:
	mkdir -p ${BUILD_DEST}

export:  build
	rsync -auvz ${BUILD_DEST}/code ansible@10.4.14.101:/home/ansible/

lint: build
	ansible-playbook -i ./build/code/hosts --syntax-check --list-tasks ./build/code/site.yml; \
	if [ $$? -eq 0 ] ; then echo "No syntax errors in ansible scripts." ; fi

clean:
	rm -rf ${BUILD_DEST}

