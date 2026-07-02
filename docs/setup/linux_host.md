[projects](/index.htm)/ [janelia](/janelia/janelia.htm)/

# Linux

## Install Docker

[docker_setup notes](../../repos/docker_setup/)

## Clone Repository and Build Docker Image

```sh
cd y_arena_odor_controller_ros
docker stop $(docker ps -aq)
docker system prune -f
docker build -t y_arena_odor_controller:latest .
```

## Send Messages to ycontroller

```sh
docker run --rm --net=host --pid=host -it y_arena_odor_controller:latest
ros2 topic pub --once /arena_odors y_arena_interfaces/msg/ArenaOdors "{arena: 0, odors: [0, 1, 2]}"
ros2 service call /get_arenas_available y_arena_interfaces/srv/GetArenas
ros2 run y_arena_odor_controller tester &
ros2 topic echo /arena_odors
```
