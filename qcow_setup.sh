#!/bin/env bash

set -o errexit
set -o nounset
set -eu -o pipefail

#set -x
#trap read debug

#################################################################################
#
#Run example: ./qcow_setup.sh -u libvirt-qemu -n NixOS-01 -d NixOS-01 -p /opt/lib/libvirt/images -s 1G -f qcow2 -c /opt/lib/libvirt/iso -i firmware-11.2.0-amd64-netinst.iso -v 1 -m 2048
#File:        qcow_setup.sh
#Date:        2022MAR08
#Author:      William Blair
#Contact:     williamblair333@gmail.com
#Tested on:   Debian 11
#To test:     Ubuntu 20+
#
#This script is intended to do the following:
#
#- helper script to setup (usually) qcow image in order to quickly get virtual
#- machines up and running
#################################################################################
function main(){

    user_name=libvirt-qemu
    image_name=NixOS-01
    image_dir=$image_name
    image_path=/opt/lib/libvirt/images
    image_size=1G
    image_format=qcow2
    cdrom_path=/opt/lib/libvirt/iso
    cdrom_iso=firmware-11.2.0-amd64-netinst.iso
    vcpus=1
    memory=2048
    #################################################################################

    while getopts u:i:d:p:s:f:c:o:v:m: flag
    do
        case "${flag}" in
            u) user_name=${OPTARG};;
            i) image_name=${OPTARG};;
            d) image_dir=${OPTARG};;
            p) image_path=${OPTARG};;
            s) image_size=${OPTARG};;
            f) image_format=${OPTARG};;
            c) cdrom_path=${OPTARG};;
            o) cdrom_iso=${OPTARG};;
            v) vcpus=${OPTARG};;
            m) memory=${OPTARG};;
            *) 
        esac
    done
    #################################################################################

    #check if the qcow image directory exists
    dir_chk=$(ls -a "$image_path"/"$image_dir")

    if [ "$image_dir" != "$dir_chk" ]; then
        mkdir "$image_path"/"$image_dir"
    else
    {
        echo "directory already exists"
    }
    fi
    #################################################################################

    su -s /bin/bash "$user_name"
    #################################################################################

    #check if the qcow image exists already
    img_chk=$(ls -a "$image_path"/"$image_dir"/"$image_name"."$image_format")

    if [ "$image_path"/"$image_dir"/"$image_name"."$image_format" != "$img_chk" ]; then
        qemu-img create -f "$image_format" "$image_path"/"$image_dir"/"$image_name"."$image_format" "$image_size"

        chown "$user_name" "$image_path"/"$image_dir"/"$image_name"."$image_format"
        chgrp "$user_name" "$image_path"/"$image_dir"/"$image_name"."$image_format"
        chown "$user_name" "$cdrom_path"/"$cdrom_iso"
        chgrp "$user_name" "$cdrom_path"/"$cdrom_iso"

        #Build the qcow / vm 
        virt-install \
        --name="$image_name" \
        --vcpus="$vcpus" \
        --memory="$memory" \
        --cdrom="$cdrom_path"/"$cdrom_iso" \
        --disk path="$image_path"/"$image_dir"/"$image_name"."$image_format"
        #--os-variant ubuntu18.04
    else
    {
        echo "image already exists. quitting"
        exit >&2
    }
    fi
    #################################################################################

    echo Now go set up the pool....

}

# Invokes the main function
main "$@"
