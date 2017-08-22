REPO_FOLDER=$1
REPO_NAME=$2
REPO_ITEMS=$3
MIRROR_IP_ADDRESS=$4
PUBLIC_ADDRESS=$(ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1')
PUBLIC_ADDRESS=($PUBLIC_ADDRESS)

if [ -z "$MIRROR_IP_ADDRESS" ]; then
  PUBLIC_ADDRESS=$(ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1')
  PUBLIC_ADDRESS=($PUBLIC_ADDRESS)
else
  PUBLIC_ADDRESS=$MIRROR_IP_ADDRESS
fi

REPOPATH="/var/www/mirrors/"
REPOFILE="${REPOPATH}/${REPO_FOLDER}/${REPO_NAME}"

mkdir -p $REPOPATH
rm $REPOFILE 2> /dev/null
touch $REPOFILE

echo "${REPOPATH}${REPO_FOLDER}"

for DIR in `find ${REPOPATH}general_mirror/ -maxdepth 1 -mindepth 1 -type d`; do
    REPO_ITEM=$(basename $DIR)
    if [[ "${REPO_ITEMS}" =~ "${REPO_ITEM}" ]]; then
       echo -e "[${REPO_ITEM}]" >> $REPOFILE
       echo -e "name=${REPO_ITEM}" >> $REPOFILE
       echo -e "baseurl=http://${PUBLIC_ADDRESS}/general_mirror/${REPO_ITEM}/" >> $REPOFILE
       echo -e "enabled=1" >> $REPOFILE
       echo -e "gpgcheck=1" >> $REPOFILE
       echo -e "gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release" >> $REPOFILE
       echo -e "\n" >> $REPOFILE
    fi
done;
