# Python

## Source Y-Arena Workspace

Source the workspace to setup the environment variables properly before running the Python script.

### Linux

```sh
source ~/yarena_ws/install/setup.bash
```

### Windows

```sh
call \yarena_ws\install\setup.bat
```

## Example Python Node

```python
import rclpy
from rclpy.node import Node

from y_arena_interfaces.msg import ArenaOdors


class ArenaOdorsPublisher(Node):

    ARENA_COUNT = 16

    def __init__(self):
        super().__init__('arena_odors_publisher')
        self.publisher_ = self.create_publisher(ArenaOdors, '/arena_odors', 10)
        timer_period = 0.5  # seconds
        self.timer = self.create_timer(timer_period, self.timer_callback)
        self._arena = 0

    def timer_callback(self):
        msg = ArenaOdors()
        msg.arena = self._arena
        msg.odors = [0, 2, 1]
        self.publisher_.publish(msg)
        self._arena = (self._arena + 1) % self.ARENA_COUNT


def main(args=None):
    rclpy.init(args=args)

    arena_odors_publisher = ArenaOdorsPublisher()

    rclpy.spin(arena_odors_publisher)

    # Destroy the node explicitly
    # (optional - otherwise it will be done automatically
    # when the garbage collector destroys the node object)
    arena_odors_publisher.destroy_node()
    rclpy.shutdown()


if __name__ == '__main__':
    main()
```
