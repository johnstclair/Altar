#!/bin/sh

qemu-system-x86_64 \
        -boot c \
        -drive format=qcow2,file=Shrine.HDD \
        -machine kernel_irqchip=off,pcspk-audiodev=audio0 \
        -smp cores=4 \
        -m 2048 \
        -rtc base=localtime \
        -audiodev pa,id=audio0 \
	-serial null \
	-serial null \
        -serial tcp:127.0.0.1:7777,server,wait &

sleep .5

python snail.py
