#!/usr/bin/env bash

sudo systemctl stop vmware-usbarbitrator vmware  vmware-networks-server

# check for headers
sudo pacman --sync  linux-headers

modprobe -a vmw_vmci vmmon

d=`date "+%s"`
td=`mktemp -d`
vd="/usr/lib/vmware/modules/source"

if test -z "$td"; then
    echo "Could not create temp dir."
    td="$1"

    echo "Trying args."
    if test -z "$td"; then
        echo "Please supply temp dir as 1st arg to this script."
        exit 0
    else
        if test ! -d "$td"; then
            echo "Supplied directory('$td') doesn't exists."
            exit 0
        fi
    fi
fi

cp $vd/vmnet.tar $td
cp $vd/vmmon.tar $td

sudo mv $vd/vmmon.tar $vd/vmmon.tar.bak.$d
sudo mv $vd/vmnet.tar $vd/vmnet.tar.bak.$d

pushd .
cd $td

tar -xf vmmon.tar
tar -xf vmnet.tar

rm -f vmmon.tar
rm -f vmnet.tar

# patch start

sed -i '/mm_segment_t old_fs;/i \
#ifdef set_fs' vmmon-only/linux/hostif.c

sed -i '/set_fs(KERNEL_DS);/a \
#endif' vmmon-only/linux/hostif.c

sed -i '/set_fs(old_fs);/i \
#ifdef set_fs' vmmon-only/linux/hostif.c

sed -i '/set_fs(old_fs);/a \
#endif' vmmon-only/linux/hostif.c

sed -i 's/netif_rx_ni(/netif_rx(/' vmnet-only/netif.c
sed -i 's/netif_rx_ni(/netif_rx(/' vmnet-only/bridge.c

# patch end

tar -cf vmmon.tar vmmon-only/
tar -cf vmnet.tar vmnet-only/

sudo cp vmmon.tar $vd/
sudo cp vmnet.tar $vd/

popd

sudo vmware-modconfig --console --install-all

sudo systemctl start vmware-usbarbitrator vmware  vmware-networks-server

