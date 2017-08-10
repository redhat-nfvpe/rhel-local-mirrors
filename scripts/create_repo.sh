REPO_FOLDER=$1
REPO_NAME=$2
REPO_ITEMS=$3
PUBLIC_ADDRESS=$(ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1')
PUBLIC_ADDRESS=($PUBLIC_ADDRESS)
REPOPATH="/var/ftp/pub/"
REPOFILE="${REPOPATH}/${REPO_FOLDER}/${REPO_NAME}"

mkdir -p $REPOPATH
rm $REPOFILE 2> /dev/null
touch $REPOFILE

echo "${REPOPATH}${REPO_FOLDER}"

for DIR in `find ${REPOPATH}general_mirror/ -maxdepth 1 -mindepth 1 -type d`; do
    REPO_ITEM=$(basename $DIR)
    echo -e "[${REPO_ITEM}]" >> $REPOFILE
    echo -e "name=${REPO_ITEM}" >> $REPOFILE
    echo -e "baseurl=ftp://${PUBLIC_ADDRESS}/pub/${REPO_FOLDER}/${REPO_ITEM}/" >> $REPOFILE

    # only enable if repo is in the list
    if [[ "${REPO_ITEMS}" =~ "${REPO_ITEM}" ]]; then
        echo -e "enabled=1" >> $REPOFILE
    else
        echo -e "enabled=0" >> $REPOFILE
    fi

    echo -e "gpgcheck=1" >> $REPOFILE
    echo -e "gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release" >> $REPOFILE
    echo -e "\n" >> $REPOFILE
done;
