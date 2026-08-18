# Module Documentation

This document provides detailed information about the various modules and systems in the Horror Survival Game Project.

## Table of Contents

- [Player System](#player-system)
- [Terrain Generation](#terrain-generation)
- [Building System](#building-system)
- [Entity System](#entity-system)
- [Save/Load System](#saveload-system)
- [Debug Tools](#debug-tools)
- [Audio System](#audio-system)

## Player System

### Overview

The player system (`modules/world_player_v2/`) is the core player implementation using a feature-centric architecture. It's designed as a coordinator that manages various self-contained features.

### Structure

```
modules/world_player_v2/
├── player.gd                    # Main coordinator
├── player.tscn                  # Player scene
├── autoload/                   # Global player singletons
│   ├── player_signals.gd      # Player-specific signals
│   └── player_stats.gd         # Player state management
└── features/                   # Self-contained features
    ├── body_camera/            # Camera control
    ├── body_movement/          # Movement mechanics
    ├── body_stats/             # Health, stamina, etc.
    ├── tool_combat/            # Combat system
    ├── tool_building/          # Construction
    ├── tool_interaction/       # Object interaction
    ├── tool_terrain/           # Terrain modification
    ├── data_inventory/         # Item management
    ├── data_containers/        # Storage system
    ├── data_pickups/           # Item pickups
    ├── ui_hud/                 # Player interface
    ├── ui_modes/               # Game mode switching
    └── ui_loading_screen/      # Loading interface
```

### Core Components

#### Player Coordinator (`player.gd`)

The main player script that wires all features together:

```gdscript
extends CharacterBody3D
class_name WorldPlayerV2

# Feature references
var movement_feature: Node = null
var camera_feature: Node = null
var combat_feature: Node = null
var inventory_feature: Node = null

# Manager references
var terrain_manager: Node = null
var building_manager: Node = null
```

**Key Features:**
- Discovers and connects feature components
- Manages feature lifecycle
- Provides interface to feature systems
- Coordinates feature interactions

#### Body Features

**Camera Feature** (`body_camera/`)
- First-person camera control
- Mouse look with sensitivity settings
- Camera smoothing and FOV control
- Raycasting for interaction

**Movement Feature** (`body_movement/`)
- WASD movement with sprint
- Jumping and crouching
- Collision detection
- Stamina-based movement

**Stats Feature** (`body_stats/`)
- Health management
- Stamina system
- Hunger and thirst
- Status effects

#### Tool Features

**Combat Feature** (`tool_combat/`)
- Weapon handling
- Attack mechanics
- Damage calculation
- Durability system

**Building Feature** (`tool_building/`)
- Block placement
- Construction mode
- Preview system
- Material selection

**Interaction Feature** (`tool_interaction/`)
- Object interaction (E key)
- Radial menu system
- Context-sensitive actions

**Terrain Feature** (`tool_terrain/`)
- Terrain modification
- Voxel manipulation
- Brush system

#### Data Features

**Inventory Feature** (`data_inventory/`)
- Item storage
- Hotbar system
- Item usage
- Stack management

**Containers Feature** (`data_containers/`)
- Storage containers
- Container inventory
- Loot system

**Pickups Feature** (`data_pickups/`)
- Item pickup logic
- Pickup animations
- Auto-collection

#### UI Features

**HUD Feature** (`ui_hud/`)
- Health/stamina display
- Crosshair
- Interaction prompts
- Minimap

**Modes Feature** (`ui_modes/`)
- Game mode switching
- Build mode
- Editor mode

### Signals

The player system uses a dedicated signal autoload:

```gdscript
# autoload/player_signals.gd
signal health_changed(current: int, maximum: int)
signal stamina_changed(current: float, maximum: float)
signal died()
signal item_equipped(item_id: String)
signal terrain_modified(position: Vector3, type: String)
signal container_opened(container_id: String)
signal building_mode_toggled(enabled: bool)
```

### Usage Example

```gdscript
# Access player from anywhere
var player = get_tree().get_first_node_in_group("player")

# Listen to player signals
PlayerSignals.health_changed.connect(_on_health_changed)

# Use player features
if player:
    player.combat_feature.attack(target)
    player.inventory_feature.add_item(item)
```

## Terrain Generation

### Overview

The terrain generation system uses advanced algorithms for procedural world creation, with C++ extensions for performance.

### Structure

```
world_marching_cubes/
├── chunk_manager.gd            # Chunk lifecycle management
├── marching_cubes_test_scene.tscn
└── ... (C++ extension files)

world_greedy_meshing/
├── gpu_greedy_meshing_manager.gd
├── greedy_meshing_test_runner.gd
└── ... (C++ extension files)

modules/world_generation/
├── material_registry.gd        # Terrain material system
└── ... generation utilities
```

### Key Components

#### Chunk Manager

Manages terrain chunks for efficient world loading:

- Chunk loading/unloading
-LOD management
- Streaming system
- Memory optimization

#### Marching Cubes

Implements the Marching Cubes algorithm for smooth terrain:

- Density field generation
- Surface extraction
- Mesh generation
- Normal calculation

#### Greedy Meshing

Optimizes mesh generation for performance:

- Face merging
- Vertex reduction
- GPU acceleration
- Batch processing

#### Material Registry

Manages terrain materials and textures:

- Material definitions
- Texture mapping
- Biome-specific materials
- Material transitions

### Configuration

Terrain generation parameters are configured through resources and constants:

```gdscript
# Chunk settings
const CHUNK_SIZE: int = 16
const CHUNK_HEIGHT: int = 256
const RENDER_DISTANCE: int = 5

# Generation settings
var terrain_seed: int = 0
var terrain_scale: float = 1.0
var terrain_height: float = 100.0
```

### Usage Example

```gdscript
# Access terrain manager
var terrain_manager = get_tree().get_first_node_in_group("terrain_manager")

# Modify terrain
terrain_manager.modify_terrain(position, modification_type, radius)

# Get terrain height
var height = terrain_manager.get_terrain_height(world_position)

# Query terrain data
var terrain_data = terrain_manager.get_terrain_data(chunk_position)
```

## Building System

### Overview

The building system (`world_building_system/`) handles construction, block placement, and prefab management.

### Structure

```
world_building_system/
├── building_manager.gd         # Main building system
├── building_generator.gd       # Structure generation
├── building_chunk.gd          # Building chunks
├── building_mesher.gd         # Building mesh generation
├── object_registry.gd         # Object registration
├── prefab_capture.gd          # Prefab saving
├── prefab_spawner.gd          # Prefab loading
├── prop_physics_settler.gd    # Physics for objects
└── debug_teleporter.gd        # Development tool
```

### Key Components

#### Building Manager

Coordinates all building operations:

- Block placement/removal
- Building validation
- Material management
- Undo/redo system

#### Object Registry

Manages placeable objects:

- Object definitions
- Placement rules
- Physics properties
- Material requirements

#### Prefab System

Save and load building templates:

- Structure capture
- Template storage
- Prefab instantiation
- Terrain integration

#### Building Generator

Procedural structure generation:

- Building templates
- Random generation
- Structure placement
- Interior generation

### Usage Example

```gdscript
# Access building manager
var building_manager = get_tree().get_first_node_in_group("building_manager")

# Place block
building_manager.place_block(world_position, block_type, rotation)

# Remove block
building_manager.remove_block(world_position)

# Save prefab
building_manager.save_prefab(start_pos, end_pos, prefab_name)

# Load prefab
building_manager.load_prefab(prefab_name, position, rotation)
```

## Entity System

### Overview

The entity system (`game/entities/`) manages all game entities including zombies, animals, and NPCs.

### Structure

```
game/entities/
├── entity_base.gd              # Base entity class
├── entity_base.tscn
├── entity_manager.gd          # Entity lifecycle
├── entity_manager.tscn
├── zombie_base.gd             # Zombie implementation
└── zombie_base.tscn
```

### Key Components

#### Entity Base

Base class for all entities:

- Common entity properties
- State management
- AI interface
- Damage system

#### Entity Manager

Manages entity lifecycle:

- Entity spawning
- Entity updating
- Entity cleanup
- Entity queries

#### Zombie Base

Specific zombie implementation:

- Zombie AI
- Attack behavior
- Pathfinding
- Animation states

### Usage Example

```gdscript
# Access entity manager
var entity_manager = get_tree().get_first_node_in_group("entity_manager")

# Spawn entity
var zombie = entity_manager.spawn_entity("zombie", position)

# Find entities nearby
var nearby_entities = entity_manager.get_entities_in_range(position, radius)

# Deal damage to entity
entity.take_damage(damage_amount, damage_type)
```

## Save/Load System

### Overview

The save/load system (`save_manager/`) provides persistent storage for game state.

### Structure

```
save_manager/
├── save_manager_v2.gd         # Main save system
├── container_registry.gd       # Container tracking
└── ... save data structures
```

### Key Components

#### Save Manager

Coordinates save/load operations:

- Save file management
- Data serialization
- World state capture
- Load validation

#### Container Registry

Tracks persistent containers:

- Container registration
- Container state
- Loot persistence
- Container queries

### Save Data Structure

```gdscript
# Save data includes:
- Player position and state
- Terrain modifications
- Building structures
- Entity states
- Container contents
- World time and weather
```

### Usage Example

```gdscript
# Access save manager
var save_manager = SaveManager

# Save game
save_manager.save_game("save_slot_1")

# Load game
save_manager.load_game("save_slot_1")

# Get save slots
var saves = save_manager.get_save_slots()

# Delete save
save_manager.delete_save("save_slot_1")
```

## Debug Tools

### Overview

The debug module (`modules/debug_module/`) provides comprehensive debugging and development tools.

### Structure

```
modules/debug_module/
├── debug_manager.gd           # Main debug controller
├── debug_preset.gd             # Debug presets
├── performance_monitor.gd      # Performance profiling
└── collision_debugger.gd       # Collision visualization
```

### Key Components

#### Debug Manager

Global debug control:

- Debug mode toggle
- Debug presets
- Debug commands
- Debug visualization

#### Performance Monitor

Real-time performance monitoring:

- FPS counter
- Memory usage
- Frame time graph
- Custom timing

#### Collision Debugger

Collision visualization:

- Collision shape display
- Physics debug draw
- Contact point visualization
- Raycast visualization

### Usage Example

```gdscript
# Enable debug mode
DebugManager.enable_debug_mode()

# Add debug marker
DebugManager.add_debug_marker(position, "test_point")

# Monitor performance
PerformanceMonitor.show_fps()
PerformanceMonitor.show_memory()

# Debug collisions
CollisionDebugger.enable_collision_debug()
CollisionDebugger.show_collision_shapes()
```

## Audio System

### Overview

The audio system (`game/sound/`) manages all game audio including music, sound effects, and ambient audio.

### Structure

```
game/sound/
├── ambient_audio_manager.gd   # Ambient sound control
└── ... audio resources
```

### Key Components

#### Ambient Audio Manager

Manages environmental audio:

- Ambient sound playback
- Zone-based audio
- Dynamic mixing
- Audio transitions

### Audio Categories

- **Music**: Background music for different game states
- **Ambience**: Environmental sounds (wind, water, birds)
- **SFX**: Sound effects (footsteps, combat, UI)
- **Voice**: Character voice and dialogue

### Usage Example

```gdscript
# Access audio manager
var audio_manager = AmbientAudioManager

# Play ambient sound
audio_manager.play_ambient("forest_ambience")

# Stop ambient
audio_manager.stop_ambient()

# Set ambient zone
audio_manager.set_ambient_zone("cave")

# Adjust volume
audio_manager.set_volume(0.8)
```

## Addons

### Performance Monitor

An editor plugin for in-editor performance monitoring.

### Renderer Fallback

Automatically selects the best available renderer for the system.

### Test Bots

Automated testing scripts for various game systems.

- `minimal_bot.gd` - Basic functionality tests
- `simple_movement_bot.gd` - Movement system tests
- `zombie_count_bot.gd` - Entity system tests
- `terrain_persistence_test_bot.gd` - Save/load tests

## Module Integration

### Communication Between Modules

Modules communicate primarily through signals:

```gdscript
# Example: Player action affecting terrain
PlayerSignals.terrain_modified.emit(position, "dig")

# Terrain manager listens
PlayerSignals.terrain_modified.connect(_on_terrain_modified)

func _on_terrain_modified(position: Vector3, type: String) -> void:
    modify_terrain_chunk(position, type)
```

### Manager Access

Managers are accessed via groups:

```gdscript
# Standard pattern for manager access
var manager = get_tree().get_first_node_in_group("manager_group_name")
```

### Common Groups

- `player` - Player entity
- `terrain_manager` - Terrain system
- `building_manager` - Building system
- `entity_manager` - Entity system
- `vegetation_manager` - Vegetation system

## Extending Modules

### Adding a New Feature

1. Create feature folder in appropriate module
2. Implement feature following module patterns
3. Define signals for communication
4. Register with coordinator if needed
5. Add tests
6. Document the feature

### Example: Adding New Weapon

```gdscript
// 1. Create weapon in tool_combat/weapons/
modules/world_player_v2/features/tool_combat/weapons/new_weapon.gd

// 2. Define weapon data
class_name NewWeapon extends Resource
@export var damage: int
@export var fire_rate: float
// ...

// 3. Implement weapon behavior
extends Node
class_name NewWeaponController

func attack() -> void:
    // Attack logic
    pass

// 4. Register in tool config
ToolConfig.register_weapon("new_weapon", weapon_data)
```

## Performance Considerations

### Terrain System
- Use chunk streaming for large worlds
- Implement LOD for distant terrain
- Optimize mesh generation frequency

### Entity System
- Use spatial partitioning for entity queries
- Implement entity pooling for frequently spawned entities
- Use AI update rate limiting

### Building System
- Batch building operations
- Use instancing for repeated structures
- Optimize collision cooking

### Player System
- Cache frequently accessed nodes
- Use signal debouncing where appropriate
- Optimize input processing

## Troubleshooting

### Common Module Issues

**Player not responding:**
- Check player coordinator is finding features
- Verify signal connections
- Check input mappings

**Terrain not generating:**
- Verify C++ extensions are loaded
- Check chunk manager initialization
- Review terrain parameters

**Building not working:**
- Verify building manager is loaded
- Check object registry
- Validate placement rules

**Entities not spawning:**
- Check entity manager initialization
- Verify entity definitions
- Review spawn conditions

## Future Module Plans

### Planned Modules
- **Quest System**: Story and mission management
- **Advanced AI**: Improved enemy behaviors
- **Weather System**: Dynamic weather effects
- **Vehicle System**: Expanded vehicle functionality
- **Crafting System**: Advanced crafting mechanics

### Module Improvements
- Enhanced modularity
- Better performance optimization
- Improved debugging tools
- Expanded documentation

---

For more detailed information about specific modules, refer to the inline documentation in the source files and the architecture documentation in `docs/ARCHITECTURE.md`.