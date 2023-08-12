#!/bin/sh
if [ $(id -u) -eq 0 ]
then
    _acp_vm_root=/srv/virt/images
    _acp_vm_session=qemu:///system
else
    _acp_vm_root="$HOME/virt/images"
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

case "$_acp_vm_distro" in
    "debian")
        _acp_vm_boot=loader=/usr/share/OVMF/OVMF_CODE.fd,loader.readonly=yes,loader.type=pflash,nvram.template=/usr/share/OVMF/OVMF_VARS.fd,loader_secure=no
        ;;
    *)
        _acp_vm_boot=uefi
        ;;
esac

# To get a list of valid osinfo options, run:
#   virt-install --osinfo list
virt-install --connect $_acp_vm_session \
    --osinfo linux2022 \
    --boot $_acp_vm_boot \
    --cpu host-passthrough \
    --disk "$_acp_vm_root/$_acp_vm_name.qcow2,size=20" \
    --graphics vnc \
    --console pty,target.type=virtio \
    --channel unix,target.type=virtio,target.name=org.qemu.guest_agent.0 \
    --video virtio \
    --autoconsole none \
    --name "$@"
