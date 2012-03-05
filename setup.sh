#!/bin/bash

QUITE="NO"
DOMAIN=""

while [ "$#" -gt 0 ]; do
    case "$1" in
        "--quite" | "-q") QUITE="YES" ;;
        "--domain" | "-d")
            if [ "$#" -gt 1 ] && shift; then
                DOMAIN="${1}"
            else
                echo "--domain|-d requires an argument"
                exit 1
            fi
        ;;
        *) echo "Unknown parameter ${1}"; exit 1;;
    esac
    shift
done

if [ "$(id -u)" -ne "0" ]; then
cat << HERE

    Setting up buddycloud requires root access.

    Rerunning as root.

HERE
sudo -H -u root ./setup.sh $*
exit $?
fi

if ! [ -f "manifests/site.pp" ]; then
if [ "$QUITE" = "NO" ]; then
cat << HERE

    Requiring the bc/puppet repository

    Checking out

HERE
fi
if ! which git &> /dev/null; then
    apt-get install -y git
fi
if git clone git://github.com/rtreffer/buddycloud-vm.git ; then
    (
        cd buddycloud-vm
        ./setup.sh $*
    )
    exit 0
else
    echo "Checkout failed. Try installing git."
    exit 1
fi
fi

if ! which puppet &> /dev/null; then
    apt-get install -y puppet
fi

if [ "$QUITE" = "NO" ]; then
cat << HERE

    Welcome to the automated buddycloud install

    This script will guide you through the setup of buddycloud.

    Press <ENTER> to continue

HERE
read DUMMY &> /dev/null
fi

if [ "$DOMAIN" = "" ]; then
cat << HERE

    buddycloud requires a domain that points to this server.

    You may try one of the following names:
$(echo $(hostname -A) $(hostname -f)|tr ' ' '\n'|sort -u|grep -v '^$'|sed 's:.*:    - \0:')

HERE
    read -p 'buddycloud domain:' -i "$(hostname -f)" DOMAIN
fi

cat > manifests/config.pp << HERE
\$buddycloud_domain="$DOMAIN"
HERE

puppet apply --modulepath=./modules/ manifests/site.pp

