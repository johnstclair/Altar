#!/bin/sh

sudo modprobe nbd
sleep .1
sudo qemu-nbd --connect=/dev/nbd0 Shrine.HDD
sleep .1
sudo mount /dev/nbd0p1 /mnt/tos
