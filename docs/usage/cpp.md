# C++

## Source Y-Arena Workspace

Source the workspace to setup the environment variables properly before running the C++ script.

### Linux

```sh
source ~/yarena_ws/install/setup.bash
```

### Windows

```sh
call \yarena_ws\install\setup.bat
```

## Example C++ Node
```cpp
#include <chrono>
#include <functional>
#include <memory>

#include "rclcpp/rclcpp.hpp"
#include "y_arena_interfaces/msg/arena_odors.hpp"

using namespace std::chrono_literals;

class ArenaOdorsPublisher : public rclcpp::Node
{
public:
  ArenaOdorsPublisher()
  : Node("arena_odors_publisher"), arena_(0)
  {
    publisher_ = this->create_publisher<y_arena_interfaces::msg::ArenaOdors>("/arena_odors", 10);
    timer_ = this->create_wall_timer(
      500ms, std::bind(&ArenaOdorsPublisher::timer_callback, this));
  }

private:
  void timer_callback()
  {
    auto message = y_arena_interfaces::msg::ArenaOdors();
    message.arena = arena_;
    message.odors = {0, 2, 1};
    publisher_->publish(message);
    arena_ = (arena_ + 1) % ARENA_COUNT;
  }
  rclcpp::TimerBase::SharedPtr timer_;
  rclcpp::Publisher<y_arena_interfaces::msg::ArenaOdors>::SharedPtr publisher_;
  size_t arena_;
  static const size_t ARENA_COUNT = 16;
};

int main(int argc, char * argv[])
{
  rclcpp::init(argc, argv);
  rclcpp::spin(std::make_shared<ArenaOdorsPublisher>());
  rclcpp::shutdown();
  return 0;
}
```
