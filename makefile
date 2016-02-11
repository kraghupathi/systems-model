SHELL = /bin/bash

BUILD_DEST=build
CODE_DEST=${BUILD_DEST}/code
VER_BRANCH=build-release
VER_FILE=VERSION
# Configuraion Server variables

ROUTER_IP=10.4.14.207
CONFIG_SERVER=10.4.14.208
CLUSTER=cluster
SMTP_SMART_HOST= smtp.admin.iiit.ac.in
ADMIN_EMAIL=alerts@vlabs.ac.in
CONFIG_SERVER_USER=vlead
CONFIG_SERVER_HOME_DIR=/home/${CONFIG_SERVER_USER}


all:  clean build 

init:
	mkdir -p ${BUILD_DEST} ${CODE_DEST}

build: init write-version
	emacs  --script elisp/publish.el
	
	@if [ "${CLUSTER}" == "" ] || [ "${CLUSTER}" == "aws" ]; then \
	  echo 'make all CLUSTER=" Cluster name" If you want to provide';\
	  sed -i 's/^public_zone.*/public_zone_address: ${ROUTER_IP}/g' ${CODE_DEST}/roles/common_vars/vars/main.yml;\
	  sed -i 's/^ansible_external.*/ansible_external_ip: ${CONFIG_SERVER}/g' ${CODE_DEST}/roles/common_vars/vars/main.yml;\
	  sed -i 's/^smtp_smart.*/smtp_smart_host: ${SMTP_SMART_HOST}/g' ${CODE_DEST}/roles/common_vars/vars/main.yml;\
          sed -i 's/^admin_email.*/admin_email_address: ${ADMIN_EMAIL}/g' ${CODE_DEST}/roles/common_vars/vars/main.yml;\
          sed -i 's/^cluster.*/cluster: ${CLUSTER}/g' ${CODE_DEST}/roles/common_vars/vars/main.yml;\
	fi
	@if [ "${CLUSTER}" != "" ] && [ "${CLUSTER}" != "aws" ]; then \
           cp -r ${CODE_DEST} ${BUILD_DEST}/${CLUSTER}; \
	   rm -rf ${CODE_DEST};\
	   sed -i 's/^prefix.*/prefix: "${CLUSTER}."/g' ${BUILD_DEST}/${CLUSTER}/roles/common_vars/vars/main.yml;\
	   sed -i 's/^public_zone.*/public_zone_address: ${ROUTER_IP}/g' ${BUILD_DEST}/${CLUSTER}/roles/common_vars/vars/main.yml;\
	   sed -i 's/^ansible_external.*/ansible_external_ip: ${CONFIG_SERVER}/g' ${BUILD_DEST}/${CLUSTER}/roles/common_vars/vars/main.yml;\
	   sed -i 's/^is_amazon.*/is_amazon: "no"/g' ${BUILD_DEST}/${CLUSTER}/roles/common_vars/vars/main.yml;\
	   sed -i 's/^smtp_smart.*/smtp_smart_host: ${SMTP_SMART_HOST}/g' ${BUILD_DEST}/${CLUSTER}/roles/common_vars/vars/main.yml;\
           sed -i 's/^admin_email.*/admin_email_address: ${ADMIN_EMAIL}/g' ${BUILD_DEST}/${CLUSTER}/roles/common_vars/vars/main.yml;\
           sed -i 's/^cluster.*/cluster: ${CLUSTER}/g' ${BUILD_DEST}/${CLUSTER}/roles/common_vars/vars/main.yml;\
	fi
# sed -i 's/^prefix.*/prefix: " "/g' ${CODE_DEST}/roles/common_vars/vars/main.yml;
#	cp -r ${CODE_DEST} ${BUILD_DEST}/base1-code
#	cp -r ${CODE_DEST} ${BUILD_DEST}/base4-code
#	mv -f ${BUILD_DEST}/${CODE_DEST}/roles/common_vars/vars/main-aws.yml ${BUILD_DEST}/${CLUSTER}/roles/common_vars/vars/main.yml 
#	mv -f ${BUILD_DEST}/aws-code/roles/common_vars/vars/main-aws.yml ${BUILD_DEST}/aws-code/roles/common_vars/vars/main.yml 
#	mv -f ${BUILD_DEST}/base1-code/roles/common_vars/vars/main-base1.yml ${BUILD_DEST}/base1-code/roles/common_vars/vars/main.yml 
#	mv -f ${BUILD_DEST}/base4-code/roles/common_vars/vars/main-base4.yml ${BUILD_DEST}/base4-code/roles/common_vars/vars/main.yml 
	rm -f ${BUILD_DEST}/docs/*.html~
# get the latest commit hash and its subject line
# and write that to the VERSION file
write-version:
	echo -n "Built from commit: " > ${CODE_DEST}/${VER_FILE}
	echo `git rev-parse HEAD` >> ${CODE_DEST}/${VER_FILE}
	echo `git log --pretty=format:'%s' -n 1` >> ${CODE_DEST}/${VER_FILE}

lint: build only-lint

release: checkout-release build write-release-version rm-ver-branch only-lint

release-and-export: release export

# get the latest tagged release and write that to the VERSION file
write-release-version:
	git checkout release
	echo -n "VERSION: " > ${CODE_DEST}/${VER_FILE}
	echo `git describe` >> ${CODE_DEST}/${VER_FILE}
	#echo "--"
	#echo `git cat-file -p $(shell git describe)` >> ${CODE_DEST}/${VER_FILE}

# lint the ansible code for syntax errors; and also list tasks
only-lint:
	ansible-playbook -i ${CODE_DEST}/hosts --syntax-check --list-tasks ${CODE_DEST}/site.yml; \
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
	rsync -auvz ${CODE_DEST} ${CONFIG_SERVER_USER}@${CONFIG_SERVER}:${CONFIG_SERVER_HOME_DIR}

clean:
	rm -rf ${BUILD_DEST}

