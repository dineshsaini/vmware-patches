# vmware-patches

vmware got fucked at every system updates, so this repo will contain my track 
history for how i got things on road last time. folder structre is 
`distro/$(uname -r)/{patch,error,version}_file`.


linux version: $uname -r: 5.19.10-arch1-1
vmware version: 16.2.4-20089737.x86_64

install??: $ bash install.sh


===============================================================================
update-1: after $uname -r >= 5.19, all patches are combined in the vmmon-only, 
            vmnet-only directories, and Arch dir is now onwards obsolete.


