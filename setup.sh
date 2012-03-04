#!/bin/bash

QUITE="NO"
DOMAIN=""

while [ "$#" -gt 0 ]; do
    case "$1" in
        "--quite" | "-q") QUITE="YES" ;;
        "--domain" | "-d")
            if [ "$#" -gt 1 ] && shift; then
                DOMAIN="${i}"
            else
                echo "--domain|-d requires an argument"
                exit 1
            fi
        ;;
        *) echo "Unknown parameter ${1}"; exit 1;;
    esac
    shift
done

if ! [ -d "manifests/site.pp" ]; then
if [ "$QUITE" -eq "NO" ]; then
cat << HERE

    Requiring the bc/puppet repository

    Checking out

HERE
fi
if git clone git://github.com/rtreffer/buddycloud-vm.git ; then
    exec ./buddycloud-vm/setup.sh $*
else
    echo "Checkout failed. Try installing git."
    exit 1
fi
fi

if [ "$(id -u)" -ne "0" ]; then
cat << HERE

    Setting up buddycloud requires root access.

    Rerunning as root.

HERE
exec sudo -H -u root "$0" $*
fi

if [ "$QUITE" -eq "NO" ]; then
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
    read -p 'buddycloud domain:' -i "$(hostname -f)"
fi

cat > manifest/config.pp << HERE
\$buddycloud_domain="$DOMAIN"
HERE

puppet apply --modulepath=./modules/ manifests/site.pp

