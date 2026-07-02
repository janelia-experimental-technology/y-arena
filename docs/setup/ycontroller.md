[projects](/index.htm)/ [janelia](/janelia/janelia.htm)/

# ycontroller

## Setup Raspberry Pi

[raspberrypi_setup notes](../../repos/raspberrypi_setup/)

    username: yuser
    hostname: ycontroller

Connect to ycontroller from host machine using SSH or web console.

## Y-Arena Source Files

Use the local source copy:

[y-arena source files](../../repos/y-arena-source/)

## Install dependencies

```sh
sudo apt install python3-filelock -y
```

## Build Software Containers

```sh
cd ~/y-arena
cd software/y_arena_odor_controller_ros
docker stop $(docker ps -aq)
docker system prune -f
docker build -t y_arena_odor_controller:latest .
```

## Run Setup Script

```sh
cd ~/y-arena/setup/
./ycontroller_setup install
sudo reboot
```

## Check systemd service

```sh
systemctl status arena-attached@00.service
systemd-analyze plot > boot_analysis.svg
```

## Updating

```sh
sudo apt update
sudo apt full-upgrade
cd ~/y-arena/setup/
./ycontroller_setup uninstall
./ycontroller_setup install
sudo reboot
```
