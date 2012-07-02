#!/bin/bash

echo "creating ec2 flavor"
mkdir ec2
(
    cd ec2
    tar -xf ../package.box
    vmware-vdiskmanager -r box-disk1.vmdk -t0 disk1.vmdk && rm box-disk1.vmdk
    kvm-img convert -f vmdk -O raw disk1.vmdk sda.img && rm disk1.vmdk
    losetup /dev/loop7 sda.img
    kpartx -a /dev/loop7
    vgscan
    while ! [ -e /dev/buddycloud/root ] ; do sleep 1 ; done
    mount /dev/buddycloud/root /mnt
    for i in proc sys dev; do mount -o bind /$i /mnt/$i ; done
    mount /dev/mapper/loop7p1 /mnt/mnt
    ( cd /mnt/mnt ; tar -cSsp . ) | ( cd /mnt/boot/ ; tar -xSsp )
    umount /mnt/mnt
    chroot /mnt /usr/bin/apt-get update
    chroot /mnt /usr/bin/apt-get install -y curl puppet cloud-init linux-image{-extra,}-virtual ubuntu-minimal
    chroot /mnt /usr/bin/apt-get install -y grub-legacy-ec2 git
    chroot /mnt /usr/bin/apt-get purge -y virtualbox-guest-dkms virtualbox-guest-utils virtualbox-guest-x11 open-vm-tools open-vm-dkms vmfs-tools
    chroot /mnt /usr/bin/apt-get purge -y nfs-common libnfsidmap2 avahi-daemon dosfstools geoip-database language-pack-gnome-en linux-image-server ntfs-3g
    chroot /mnt /usr/bin/apt-get purge -y xauth xfonts-base xfonts-utils xserver-xorg-core
    chroot /mnt /usr/bin/apt-get autoremove -y
    chroot /mnt /usr/sbin/userdel -rf vagrant
    chroot /mnt /usr/sbin/useradd -m buddycloud -G adm,admin,users,netdev -s /bin/bash
    rm /mnt/etc/ssh/*_key*
    cd /mnt/root
    git clone git://github.com/buddycloud/buddycloud-vm.git /mnt/root/buddycloud-vm
    cd /mnt/root/buddycloud-vm
    cat > manifests/config.pp << _HERE_
buddycloud_domain=\$externalhost
buddycloud_ip=\$externalip
_HERE_

    cat > /mnt/etc/cloud/cloud.cfg << _HERE_
user: buddycloud
disable_root: 1
preserve_hostname: False
# datasource_list: ["NoCloud", "ConfigDrive", "OVF", "MAAS", "Ec2", "CloudStack"]

cloud_init_modules:
 - bootcmd
 - resizefs
 - set_hostname
 - update_hostname
 - update_etc_hosts
 - ca-certs
 - rsyslog
 - ssh

cloud_config_modules:
 - mounts
 - ssh-import-id
 - locale
 - set-passwords
 - grub-dpkg
 - apt-pipelining
 - apt-update-upgrade
 - landscape
 - timezone
 - puppet
 - chef
 - salt-minion
 - mcollective
 - disable-ec2-metadata
 - runcmd
 - byobu

cloud_final_modules:
 - rightscale_userdata
 - scripts-per-once
 - scripts-per-boot
 - scripts-per-instance
 - scripts-user
 - keys-to-console
 - phone-home
 - final-message
_HERE_

    cat > /mnt/etc/cloud/build.info << _HERE_
build_name: server
serial: 20120702
_HERE_

    cat > /mnt/etc/rc.local << _HERE_
#!/bin/bash

if ! [ -f /etc/ssh/ssh_host_rsa_key.pub ] ; then
    apt-get install --reinstall openssh-server
    restart ssh
fi
if ! [ -d ~buddycloud/.ssh ] ; then
    mkdir ~buddycloud/.ssh
    chown buddycloud:buddycloud ~buddycloud/.ssh
    chmod 0700 ~buddycloud/.ssh
fi
if [ -f ~buddycloud/.ssh/authorized_keys ] ; then
    echo >> ~buddycloud/.ssh/authorized_keys
    /usr/bin/ec2metadata --public-keys|sed 's:\[\(.*\)\]:\1:'|sed "s:'::g"|tr ',' '\n' >> ~buddycloud/.ssh/authorized_keys
else
    /usr/bin/ec2metadata --public-keys|sed 's:\[\(.*\)\]:\1:'|sed "s:'::g"|tr ',' '\n' > ~buddycloud/.ssh/authorized_keys
    chown buddycloud:buddycloud ~buddycloud/.ssh/authorized_keys
    chmod 0600 ~buddycloud/.ssh/authorized_keys
fi

cd /root/buddycloud-vm
cp manifests/config.pp manifests/config.pp.bak
git checkout -- manifests/config.pp
git pull
cp manifests/config.pp.bak manifests/config.pp
puppet apply --modulepath=./modules/ manifests/site.pp
/usr/local/sbin/update-buddycloud
_HERE_

    umount /mnt/*
    dd if=/dev/zero of=/mnt/zero bs=$((1*1024*1024))
    sync
    sleep 1
    sync
    sleep 1
    rm /mnt/zero
    cd /
    umount /mnt
)
dd if=/dev/buddycloud/root of=buddycloud_dense.img bs=$((1*1024*1024))
vgchange -a n buddycloud
kpartx -d /dev/loop7
losetup -d /dev/loop7
rm -rf ec2
kvm-img convert -f raw -O raw buddycloud_dense.img buddycloud.img
rm buddycloud_dense.img
cat buddycloud.img | pbzip2 -9 > buddycloud.img.bz2
rm buddycloud.img
