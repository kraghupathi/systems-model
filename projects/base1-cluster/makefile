BUILD_DEST=build
VER_BRANCH=build-release
CONFIG_SERVER=10.4.14.101
CONFIG_SERVER_USER=vlead-jockey
CONFIG_SERVER_HOME_DIR=/home/${CONFIG_SERVER_USER}


all:  build write-version

init:
	mkdir -p ${BUILD_DEST}

build: init
	emacs  --script elisp/publish.el
	rm -f ${BUILD_DEST}/docs/*.html~

# get the latest commit hash and its subject line
# and write that to the VERSION file
write-version:
	echo -n "Built from commit: " > ${BUILD_DEST}/code/VERSION
	echo `git rev-parse HEAD` >> ${BUILD_DEST}/code/VERSION
	echo `git log --pretty=format:'%s' -n 1` >> ${BUILD_DEST}/code/VERSION

lint: build only-lint

release: checkout-release build write-release-version rm-ver-branch only-lint

release-and-export: release export

# get the latest tagged release and write that to the VERSION file
write-release-version:
	git checkout release
	echo -n "VERSION: " > ${BUILD_DEST}/code/VERSION
	echo `git describe` >> ${BUILD_DEST}/code/VERSION
	#echo "--"
	#echo `git cat-file -p $(shell git describe)` >> ${BUILD_DEST}/code/VERSION

# lint the ansible code for syntax errors; and also list tasks
only-lint:
	ansible-playbook -i ${BUILD_DEST}/code/hosts --syntax-check --list-tasks ${BUILD_DEST}/code/site.yml; \
	if [ $$? -eq 0 ] ; then echo "No syntax errors in ansible scripts." ; fi

# checkout the release branch, find the latest tag and put it that snapshot in
# a temporary branch
checkout-release:
	git checkout release
	if [ -z $(shell git describe --abbrev=0) ]; then echo "No tagged release found!"; exit 1; fi
	git checkout -b ${VER_BRANCH} $(shell git describe --abbrev=0)

# remove the temporarily created branch
rm-ver-branch:
	git checkout release
	git branch -d ${VER_BRANCH}

# copy the code dir to our configuration-server
export:
	rsync -auvz ${BUILD_DEST}/code ${CONFIG_SERVER_USER}@${CONFIG_SERVER}:${CONFIG_SERVER_HOME_DIR}

clean:
	rm -rf ${BUILD_DEST}

