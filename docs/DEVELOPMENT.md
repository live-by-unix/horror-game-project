# Development Guide

This guide covers the development workflow, coding standards, testing practices, and contribution guidelines for the Horror Survival Game Project.

## Development Workflow

### Setting Up Your Development Environment

1. **Fork and Clone:**
   ```bash
   git clone https://github.com/yourusername/horror-survival-game-project.git
   cd horror-survival-game-project
   ```

2. **Create a Feature Branch:**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Set Up Godot:**
   - Open the project in Godot 4.6+
   - Let Godot import all assets
   - Configure your preferred external editor

### Development Cycle

1. **Plan Your Feature:**
   - Review the architecture documentation
   - Understand existing patterns in the codebase
   - Plan how your feature fits the modular architecture

2. **Implement:**
   - Follow the feature-centric organization
   - Use signals for component communication
   - Add inline documentation

3. **Test:**
   - Create test bots for automated testing
   - Test manually in the editor
   - Use debug tools to verify behavior

4. **Document:**
   - Update relevant documentation
   - Add code comments for complex logic
   - Update this guide if needed

5. **Commit:**
   ```bash
   git add .
   git commit -m "feat: add your feature description"
   ```

6. **Push and Create Pull Request:**
   ```bash
   git push origin feature/your-feature-name
   ```

## Coding Standards

### GDScript Guidelines

#### File Organization
- **One class per file** - Keep files focused
- **Feature-based folders** - Group related functionality
- **Clear naming** - Use descriptive names for files and classes

#### Naming Conventions
```gdscript
# Classes: PascalCase
class_name PlayerController

# Functions: snake_case
func move_player() -> void:
    pass

# Variables: snake_case
var player_health: int = 100

# Constants: UPPER_SNAKE_CASE
const MAX_HEALTH: int = 100

# Signals: snake_case
signal health_changed(current: int, maximum: int)

# Private members: underscore prefix
var _internal_state: int = 0
```

#### Type Hints
Always use type hints for better performance and IDE support:
```gdscript
func calculate_damage(base_damage: int, multiplier: float) -> int:
    return int(base_damage * multiplier)

var health: int = 100
var position: Vector3 = Vector3.ZERO
var inventory: Array[ItemData] = []
```

#### Documentation
Add class and function documentation:
```gdscript
## PlayerController handles player movement and input processing
class_name PlayerController

## Moves the player in the specified direction
## @param direction: The direction to move in
## @param speed: The movement speed multiplier
func move(direction: Vector3, speed: float) -> void:
    velocity = direction * speed
```

### Code Structure

#### Class Structure
```gdscript
extends Node
class_name MyClass

# ============================================================================
# CONSTANTS
# ============================================================================
const MAX_VALUE: int = 100

# ============================================================================
# EXPORT VARIABLES
# ============================================================================
@export var enabled: bool = true

# ============================================================================
# PUBLIC VARIABLES
# ============================================================================
var public_value: int = 0

# ============================================================================
# PRIVATE VARIABLES
# ============================================================================
var _internal_value: int = 0

# ============================================================================
# SIGNALS
# ============================================================================
signal value_changed(new_value: int)

# ============================================================================
# GODOT LIFECYCLE
# ============================================================================
func _ready() -> void:
    pass

func _process(delta: float) -> void:
    pass

# ============================================================================
# PUBLIC METHODS
# ============================================================================
func public_method() -> void:
    pass

# ============================================================================
# PRIVATE METHODS
# ============================================================================
func _private_method() -> void:
    pass
```

#### Signal Usage
Use signals for decoupled communication:
```gdscript
# Define signals
signal health_changed(current: int, maximum: int)
signal player_died()

# Emit signals
health_changed.emit(current_health, max_health)

# Connect signals
health_changed.connect(_on_health_changed)

# Handle signals
func _on_health_changed(current: int, maximum: int) -> void:
    update_health_ui(current, maximum)
```

### Resource Usage

Use Godot Resources for data-driven design:
```gdscript
# item_data.gd
class_name ItemData extends Resource

@export var id: String
@export var name: String
@export var description: String
@export var icon: Texture2D
@export var weight: float = 1.0
@export var max_stack: int = 99
```

Create resources in the editor or programmatically:
```gdscript
var item_data = ItemData.new()
item_data.id = "wood"
item_data.name = "Wood"
item_data.weight = 0.5
```

## Architecture Patterns

### Feature-Centric Design

Organize code by feature, not file type:
```
features/combat/
├── combat_system.gd
├── combat_system.tscn
├── signals.gd
└── weapons/
    ├── pistol.gd
    ├── pistol.tscn
    └── sounds/
```

### Autoload Usage

Use autoloads sparingly for truly global systems:
- **Game Manager**: Overall game state
- **Event Bus**: Global signal hub
- **Save Manager**: Persistence
- **Configuration**: Game settings

Avoid autoloads for feature-specific functionality.

### Manager Pattern

Use managers accessed via groups:
```gdscript
# Find manager
var terrain_manager = get_tree().get_first_node_in_group("terrain_manager")

# Use manager
terrain_manager.modify_terrain(position, modification_type)
```

### Component Pattern

Build complex objects from components:
```gdscript
# Player has multiple feature components
var movement_component: Node
var combat_component: Node
var inventory_component: Node

# Each component is self-contained
movement_component.move(direction)
combat_component.attack(target)
inventory_component.add_item(item)
```

## Testing

### Test Bots

Create automated test bots in `addons/tests/`:
```gdscript
extends Node
class_name MovementTestBot

func _ready() -> void:
    run_tests()

func run_tests() -> void:
    test_forward_movement()
    test_backward_movement()
    test_jump()
    print("All movement tests passed!")

func test_forward_movement() -> void:
    # Test implementation
    pass
```

### Manual Testing

Use the debug tools for manual testing:
- **DebugManager**: Enable debug features
- **PerformanceMonitor**: Profile performance
- **CollisionDebugger**: Visualize collisions

### Testing Checklist

Before submitting code:
- [ ] Functionality works as expected
- [ ] No console errors or warnings
- [ ] Performance is acceptable
- [ ] Edge cases are handled
- [ ] Code follows style guidelines
- [ ] Documentation is updated

## Debugging

### Debug Tools

**DebugManager:**
```gdscript
# Enable debug mode
DebugManager.enable_debug_mode()

# Add debug markers
DebugManager.add_debug_marker(position, "test_point")

# Log debug messages
DebugManager.log_debug("Test message", "category")
```

**PerformanceMonitor:**
```gdscript
# Monitor FPS
PerformanceMonitor.show_fps()

# Monitor memory
PerformanceMonitor.show_memory()

# Custom timing
PerformanceMonitor.start_timing("operation")
# ... do operation ...
PerformanceMonitor.end_timing("operation")
```

**CollisionDebugger:**
```gdscript
# Enable collision visualization
CollisionDebugger.enable_collision_debug()

# Show collision shapes
CollisionDebugger.show_collision_shapes()
```

### Common Debugging Techniques

**Print Debugging:**
```gdscript
print("Debug: variable = ", variable)
print_stack()  # Print call stack
```

**Breakpoints:**
- Set breakpoints in Godot Editor
- Use debugger to inspect variables
- Step through code execution

**Profiling:**
- Use Godot's built-in profiler
- Monitor frame times
- Identify bottlenecks

## Performance Optimization

### General Guidelines

1. **Object Pooling:** Reuse objects instead of creating/destroying
2. **Spatial Partitioning:** Use octrees or grids for spatial queries
3. **LOD Systems:** Use level of detail for distant objects
4. **Batch Processing:** Group similar operations together

### GDScript Optimization

```gdscript
# Cache node references
var _cached_node: Node

func _ready() -> void:
    _cached_node = get_node("Path/To/Node")

# Use typed arrays
var typed_array: Array[int] = []

# Avoid unnecessary allocations
# Bad:
for i in range(1000):
    var temp_array = []
    # ...

# Good:
var temp_array = []
for i in range(1000):
    temp_array.clear()
    # ...
```

### Terrain Optimization

- Use chunk-based loading
- Implement LOD for distant terrain
- Optimize mesh generation
- Use GPU acceleration where possible

## Contribution Guidelines

### Before Contributing

1. **Read Documentation:**
   - Review `docs/ARCHITECTURE.md`
   - Read `docs/GETTING_STARTED.md`
   - Understand the project structure

2. **Check Existing Issues:**
   - Look for related issues or PRs
   - Comment on existing issues if relevant
   - Create new issue if needed

3. **Plan Your Approach:**
   - Design your solution
   - Consider edge cases
   - Plan testing approach

### Making Changes

1. **Follow Coding Standards:**
   - Use proper naming conventions
   - Add type hints
   - Include documentation

2. **Test Thoroughly:**
   - Create test bots if appropriate
   - Test manually
   - Check performance impact

3. **Document Changes:**
   - Update relevant documentation
   - Add code comments
   - Update CHANGELOG if applicable

### Submitting Changes

1. **Commit Messages:**
   ```bash
   # Use conventional commit format
   feat: add new combat system
   fix: resolve terrain collision bug
   docs: update architecture documentation
   refactor: optimize player movement
   ```

2. **Pull Request:**
   - Describe your changes
   - Link related issues
   - Include screenshots if applicable
   - Document testing performed

3. **Code Review:**
   - Respond to feedback promptly
   - Make requested changes
   - Keep PRs focused and small

### Code Review Criteria

- [ ] Follows coding standards
- [ ] Includes documentation
- [ ] Has appropriate tests
- [ ] Performance is acceptable
- [ ] No security issues
- [ ] Compatible with project goals

## Tools and Extensions

### Recommended Godot Extensions

- **GDScript Formatter**: Auto-format code
- **Git Integration**: Version control in editor
- **Profiler**: Performance profiling
- **Debugger**: Advanced debugging

### External Tools

- **Visual Studio Code**: Lightweight code editor
- **Git**: Version control
- **Blender**: 3D modeling (if modifying assets)
- **Audacity**: Audio editing (if modifying sounds)

## Common Tasks

### Adding a New Player Feature

1. Create feature folder:
   ```
   modules/world_player_v2/features/your_feature/
   ```

2. Create feature script:
   ```gdscript
   extends Node
   class_name YourFeature

   signal your_event(data: Variant)

   func _ready() -> void:
       pass
   ```

3. Register in player:
   ```gdscript
   # player.gd
   var your_feature: Node = null

   func _ready() -> void:
       your_feature = components_node.get_node_or_null("YourFeature")
   ```

### Adding a New Item

1. Create item definition:
   ```gdscript
   extends Resource
   class_name YourItemData

   @export var id: String
   @export var name: String
   # ... other properties
   ```

2. Add to item registry
3. Create model and sounds
4. Implement item behavior

### Modifying Terrain

1. Edit terrain parameters
2. Modify density functions
3. Update material registry
4. Test with different seeds

## Troubleshooting Development Issues

### Common Problems

**Import Errors:**
- Check Godot version compatibility
- Verify file paths
- Reimport assets if needed

**Performance Issues:**
- Use PerformanceMonitor
- Check for memory leaks
- Optimize heavy operations

**C++ Extension Issues:**
- Verify GDExtension setup
- Check compiler compatibility
- Review extension code

**Signal Connection Issues:**
- Verify signal names
- Check connection timing
- Use call_deferred if needed

### Getting Help

1. **Check Documentation:**
   - Review architecture docs
   - Check inline comments
   - Examine similar code

2. **Use Debug Tools:**
   - Enable debug output
   - Add print statements
   - Use breakpoints

3. **Community:**
   - Check GitHub issues
   - Ask questions in discussions
   - Review existing PRs

## Best Practices

### DO

- Follow the feature-centric architecture
- Use signals for component communication
- Add comprehensive documentation
- Test thoroughly before submitting
- Optimize for performance
- Handle edge cases gracefully
- Use type hints consistently

### DON'T

- Create tight coupling between components
- Use autoloads for feature-specific code
- Skip documentation
- Submit untested code
- Ignore performance impact
- Leave TODOs in production code
- Mix naming conventions

## Resources

### Internal Documentation
- **Architecture**: `docs/ARCHITECTURE.md`
- **Getting Started**: `docs/GETTING_STARTED.md`
- **Architecture Suggestions**: `modules/ARCHITECTURE_SUGGESTIONS.md`

### External Resources
- **Godot Documentation**: https://docs.godotengine.org/
- **GDScript Reference**: https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_basics.html
- **Best Practices**: https://docs.godotengine.org/en/stable/tutorials/best_practices/index.html

---

**Happy coding! Contributions are what make open-source projects thrive.**