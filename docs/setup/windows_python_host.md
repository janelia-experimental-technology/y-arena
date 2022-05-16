# Windows 10

Check for new Windows updates and install all.

<https://docs.ros.org/en/dashing/Installation/Windows-Install-Binary.html>

## Install Chocolatey

<https://chocolatey.org/>

## Install Python and Dependencies

Open an administrative command prompt.

```sh
mkdir c:\opt\chocolatey
set PYTHONNOUSERSITE=1
set ChocolateyInstall=c:\opt\chocolatey
choco source add -n=ros-win -s="https://aka.ms/ros/public" --priority=1
choco upgrade ros-dashing-desktop -y --execution-timeout=0
```

## Environment Setup

```sh
call C:\opt\ros\dashing\x64\local_setup.bat
set | findstr -i ROS
```

## Create a Workspace and Clone Y-Arena Repository

```sh
md \yarena_ws\src
cd \yarena_ws\src
git clone https://github.com/janelia-ros/y_arena_odor_controller_ros.git
```

## Build the Workspace with Colcon

```sh
cd \yarena_ws
colcon build --merge-install
```

## Source Y-Arena Workspace

```sh
call \yarena_ws\install\setup.bat
```
