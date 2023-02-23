#!/bin/sh
_acp_vm_root="$HOME/virt/images"
_acp_vm_session=qemu:///session
_acp_vm_name=${1:---help}

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

virt-install --connect $_acp_vm_session \
    --osinfo linux2020 \
    --boot uefi \
    --cpu host-passthrough \
    --disk "$_acp_vm_root/$_acp_vm_name.qcow2,size=20" \
    --graphics vnc \
    --console pty,target.type=virtio \
    --channel unix,target.type=virtio,target.name=org.qemu.guest_agent.0 \
    --video virtio \
    --autoconsole none \
    --name "$@"
