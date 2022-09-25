#!/usr/bin/env bash

vd="/usr/lib/vmware/modules/source"

sudo systemctl stop vmware-usbarbitrator vmware  vmware-networks-server

tar -cf vmmon.tar vmmon-only/
tar -cf vmnet.tar vmnet-only/

sudo mv vmmon.tar $vd/
sudo mv vmnet.tar $vd/

sudo vmware-modconfig --console --install-all

sudo systemctl start vmware-usbarbitrator vmware  vmware-networks-server


