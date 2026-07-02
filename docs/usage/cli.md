[projects](/index.htm)/ [janelia](/janelia/janelia.htm)/

# Docker Command Line
```sh
docker build -t y_arena_odor_controller:latest ./software/y_arena_odor_controller_ros/
docker run --rm --net=host --pid=host -it y_arena_odor_controller:latest
ros2 service call /get_arenas_available y_arena_interfaces/srv/GetArenas
ros2 topic pub --once /arena_odors y_arena_interfaces/msg/ArenaOdors "{arena: 0, odors: [0, 2, 1]}"
ros2 run y_arena_odor_controller tester &
ros2 topic echo /arena_odors
```
