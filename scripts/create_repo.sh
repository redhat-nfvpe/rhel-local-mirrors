REPO_FOLDER=$1
REPO_NAME=$2
PUBLIC_ADDRESS=$(ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1')
PUBLIC_ADDRESS=($PUBLIC_ADDRESS)
REPOPATH="/var/ftp/pub/"
REPOFILE="${REPOPATH}/${REPO_FOLDER}/${REPO_NAME}"

mkdir -p $REPOPATH
rm $REPOFILE 2> /dev/null
touch $REPOFILE

for DIR in `find ${REPOPATH}${REPO_FOLDER}/* -maxdepth 1 -mindepth 1 -type d`; do
    echo -e "[`basename $DIR`]" >> $REPOFILE
    echo -e "name=`basename $DIR`" >> $REPOFILE
    echo -e "baseurl=ftp://${PUBLIC_ADDRESS}/pub/${REPO_FOLDER}/`basename $DIR`/" >> $REPOFILE
    echo -e "enabled=1" >> $REPOFILE
    echo -e "gpgcheck=1" >> $REPOFILE
    echo -e "gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release" >> $REPOFILE
    echo -e "\n" >> $REPOFILE
done;
