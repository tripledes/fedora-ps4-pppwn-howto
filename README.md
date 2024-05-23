# PS4 PPPwn with Fedora (aarch64)

**DISCLAIMER**: This work is based on the work published by others and its meant to serve as a reference for getting it to work on a RPI 3 B+ running Fedora 40.

## Prerequisites

For the steps below to work you need a working Fedora 40 installation in a Raspberry PI with a working Ethernet port. The steps have been tested with the following setup:

- Raspberry PI 3 Model B+, anything newer should work
- Fedora 40 installed and a working wireless connection, follow [the official documenation](https://docs.fedoraproject.org/en-US/quick-docs/raspberry-pi/), I have personally used the Fedora Server Edition
- Ethernet cable to connect the RPI3 to the PS4
- USB storage for loading the GoldHEN payload
- Some patience ;-)

## Setting it up

- In your RPI do the following
  ```shell
  $ git clone --recurse-submodules https://github.com/tripledes/fedora-ps4-pppwn-howto.git
  $ cd fedora-ps4-pppwn-howto
  $ sudo ./install.sh 1100 # 900 1000
  ```
- Edit the _/usr/local/etc/pppwn.conf_ file and adjust the values
- Configure your PS4 PPPoe connection as instructed by all the tutorials out there and shut it down completely
- Shut your Raspberry PI down, plug its power to the PS4's back USB port and use the Ethernet cable to connect the RPI and the PS4 directly
- If you haven't used GoldHEN before, you'll need to copy the [goldhen.bin](payloads/goldhen.bin) to the root of a USB pendrive, using FAT or exFAT, and plug it to your PS4's front USB ports, this is only needed for the first time, once successful the USB pendrive can be safely removed

## Make it so

- With your RPI connected to your PS4, both using the USB port as its power source and the Ethernet port, turn on your PS4
- The PS4 boots faster than the RPI3 B+, use the patience ;-)
- The PPPwn service will start and execute the required commands, if successful, the RPI will shut down itself, if not it will keep restarting the process
- Successful attempts will show the usual **PPPwned** message

## Cleaning up

```shell
$ sudo ./install.sh uninstall
```

## Credits

This repo is based on the great work of the PS4 scene, kudos to:

- TheFlow - [Original PPPwn](https://github.com/TheOfficialFloW/PPPwn)
- SiSTRo - [GoldHEN](https://github.com/GoldHEN/GoldHEN)
- stooged - [PI-Pwn](https://github.com/stooged/PI-Pwn)
- xfangfang - [PPPwn C++](https://github.com/xfangfang/PPPwn_cpp)
- All others that have made this possible
