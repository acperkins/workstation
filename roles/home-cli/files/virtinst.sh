#!/bin/sh
if [ $(id -u) -eq 0 ]
then
    _acp_vm_root=/srv/virt/images
    _acp_vm_session=qemu:///system
else
    _acp_vm_root="$HOME/data/virt/images"
    _acp_vm_session=qemu:///session
fi
_acp_vm_name=${1:---help}
_acp_vm_distro=$(. /etc/os-release; echo $ID)

case "$_acp_vm_name" in
    "--help" | -*)
        echo "Usage: virtinst vmname --cdrom install.iso [other virt-install options]" >&2
        exit 1
        ;;
    *)
        ;;
esac

# Create the directory if it doesn't exist already.
if ! [ -d "$_acp_vm_root" ]
then
    mkdir -p "$_acp_vm_root"
fi
if ! [ -f "$_acp_vm_root/empty.iso" ]
then
    touch "$_acp_vm_root/empty.iso"
fi

case "$_acp_vm_distro" in
    "debian")
        _acp_vm_boot=loader=/usr/share/edk2/ovmf/OVMF_CODE.fd,loader.readonly=yes,loader.type=pflash,nvram.template=/usr/share/edk2/ovmf/OVMF_VARS.fd,loader_secure=no
        ;;
    *)
        _acp_vm_boot=uefi
        ;;
esac

if [ -r "$_acp_vm_root/$_acp_vm_name.raw" ]
then
    _acp_vm_disk=$_acp_vm_root/$_acp_vm_name.raw
else
    _acp_vm_disk=$_acp_vm_root/$_acp_vm_name.qcow2
fi

if ! [ -r "$_acp_vm_disk" ]
then
    qemu-img create -f qcow2 $_acp_vm_disk 20G
fi

# To get a list of valid osinfo options, run:
#   virt-install --osinfo list
# Sizes are based on RHEL 9 minimum recommendations.
virt-install --connect $_acp_vm_session \
    --osinfo linux2022 \
    --accelerate \
    --boot $_acp_vm_boot \
    --vcpus 1 \
    --ram 1536 \
    --disk "$_acp_vm_disk" \
    --network network:default,model=virtio \
    --graphics vnc \
    --console pty,target.type=virtio \
    --serial pty \
    --channel unix,target.type=virtio,target.name=org.qemu.guest_agent.0 \
    --video bochs \
    --autoconsole none \
    --import \
    --cdrom $_acp_vm_root/empty.iso \
    --boot menu=on \
    --name "$@"
