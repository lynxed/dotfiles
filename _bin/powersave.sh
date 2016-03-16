#!/bin/bash

function switch_to_battery() {
    echo '1500' > '/proc/sys/vm/dirty_writeback_centisecs'

    echo '1' > '/sys/module/snd_hda_intel/parameters/power_save'
    echo '0' > '/proc/sys/kernel/nmi_watchdog'

    for d in /sys/bus/i2c/devices/*; do
        echo 'auto' > "$d/device/power/control";
    done

    for d in /sys/bus/pci/devices/*; do
        echo 'auto' > "$d/power/control";
    done

    ethtool -s enp2s0f1 wol d;
}

function switch_to_ac() {
    echo 'Activating AC-settings'

    echo '500' > '/proc/sys/vm/dirty_writeback_centisecs'

    echo '0' > '/sys/module/snd_hda_intel/parameters/power_save'
    echo '1' > '/proc/sys/kernel/nmi_watchdog'

    for d in /sys/bus/i2c/devices/*; do
        echo 'on' > "$d/device/power/control";
    done

    for d in /sys/bus/pci/devices/*; do
        echo 'on' > "$d/power/control";
    done

    ethtool -s enp2s0f1 wol g;
}

#if [ $(cat '/sys/class/power_supply/AC/online') == '0' ]; then
#    switch_to_battery
#else
#    switch_to_ac
#fi

switch_to_battery
