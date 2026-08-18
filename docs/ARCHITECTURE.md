# Architecture Documentation

## Overview

The Horror Survival Game Project uses a **feature-centric modular architecture** designed for scalability, maintainability, and ease of development. This document explains the core architectural principles, system organization, and key patterns used throughout the project.

## Core Principles

### 1. Organize by Feature
Group code by functionality and meaning rather than file type. Each feature contains all related scripts, scenes, assets, and UI components.

**Example:**
```
player/
├── body/           # Physical player components
├── stats/          # Player state management
├── items/          # Inventory and equipment
└── actions/        # Player behaviors
```

### 2. Self-Contained Modules
Each module folder contains everything needed for that feature:
- Scripts (`.gd`)
- Scenes (`.tscn`)
- Models (`.glb`)
- Textures (`.png`)
- Sounds (`.mp3`, `.wav`)
- UI components (subfolder)

### 3. Signals for Communication
Use Godot's signal system for decoupled component interaction. Components communicate through events rather than direct references.

**Example:**
```gdscript
# autoloads/event_bus.gd
signal player_died
signal item_picked_up(item_id: String)
signal quest_completed(quest_id: String)

# Usage anywhere:
EventBus.player_died.emit()
EventBus.item_picked_up.connect(_on_item_picked_up)
```

### 4. Custom Resources for Data
Use Godot's Resource system for data-driven design. Items, recipes, stats, and configuration data are defined as Resources.

**Example:**
```gdscript
# player/items/weapons/weapon_data.gd
class_name WeaponData extends Resource

@export var id: String
@export var name: String
@export var damage: int
@export var fire_rate: float
@export var ammo_type: String
@export var model: PackedScene
@export var sounds: Dictionary
```

### 5. Autoloads for Global Access
Use autoloaded singletons sparingly for truly global systems:
- Game state management
- Event buses
- Save/load systems
- Configuration data

## System Architecture

### Project Structure

```
horror-survival-game-project/
├── addons/              # Godot plugins and extensions
├── game/                # Core game systems
├── modules/             # Feature modules
├── models/              # 3D assets
├── save_manager/        # Persistence system
├── world_*/             # World generation and management
└── docs/               # Documentation
```

### Module Organization

#### Core Modules

**`modules/world_player_v2/`** - Current Player System
The modern, feature-centric player implementation:
- `player.gd` - Main coordinator script
- `autoload/` - Global player singletons (signals, stats)
- `features/` - Self-contained player features
  - `body_camera/` - Camera control
  - `body_movement/` - Movement mechanics
  - `body_stats/` - Health, stamina, etc.
  - `tool_combat/` - Combat system
  - `tool_building/` - Construction
  - `tool_interaction/` - Object interaction
  - `tool_terrain/` - Terrain modification
  - `data_inventory/` - Item management
  - `data_containers/` - Storage system
  - `ui_hud/` - Player interface
  - `ui_modes/` - Game mode switching

**`modules/world_generation/`** - Terrain System
Procedural terrain generation using:
- Marching Cubes algorithm for smooth terrain
- Material registry for terrain textures
- Density functions for terrain shape

**`world_marching_cubes/`** - Terrain Generation Engine
C++ extension for high-performance terrain generation:
- Chunk management
- Density field generation
- Mesh generation
- Collision handling

**`world_greedy_meshing/`** - Mesh Optimization
GPU-accelerated mesh optimization:
- Greedy meshing algorithm
- Large chunk handling
- Performance optimization

**`world_building_system/`** - Construction System
Building and construction mechanics:
- Block placement and removal
- Prefab system for saving/loading structures
- Object registry for managed placement
- Physics integration for realistic objects

**`game/entities/`** - Entity System
Game entities (zombies, animals, NPCs):
- `entity_base.gd` - Base entity class
- `entity_manager.gd` - Entity lifecycle management
- `zombie_base.gd` - Zombie AI and behavior

### Autoloaded Singletons

The project uses several autoloaded singletons defined in `project.godot`:

```gdscript
[autoload]
DebugManager="*res://modules/debug_module/debug_manager.gd"
SaveManager="*res://save_manager/save_manager_v2.gd"
ContainerRegistry="*res://save_manager/container_registry.gd"
PerformanceMonitor="*res://modules/debug_module/performance_monitor.gd"
PlayerSignals="*res://modules/world_player_v2/autoload/player_signals.gd"
PlayerStats="*res://modules/world_player_v2/autoload/player_stats.gd"
ContainerSignals="*res://modules/world_player_v2/features/data_containers/signals.gd"
AmbientAudioManager="*res://game/sound/ambient_audio_manager.gd"
CollisionDebugger="*res://modules/debug_module/collision_debugger.gd"
ToolConfig="*res://modules/world_player_v2/features/tool_combat/tool_config.gd"
RendererFallback="*res://addons/renderer_fallback/renderer_fallback.gd"
```

## Key Architectural Patterns

### Feature-Centric Player Design

The player system (`WorldPlayerV2`) uses a coordinator pattern:

```gdscript
extends CharacterBody3D
class_name WorldPlayerV2

# Feature references
var movement_feature: Node = null
var camera_feature: Node = null
var combat_feature: Node = null

func _ready() -> void:
    # Find features in Components node
    var components_node = get_node_or_null("Components")
    if components_node:
        movement_feature = components_node.get_node_or_null("Movement")
        camera_feature = components_node.get_node_or_null("Camera")
    
    # Find modes in Modes node
    var modes_node = get_node_or_null("Modes")
    if modes_node:
        combat_feature = modes_node.get_node_or_null("CombatSystem")
```

This design allows:
- Easy addition/removal of features
- Clear separation of concerns
- Independent feature development
- Simplified testing

### Signal-Based Communication

Components communicate through signals rather than direct references:

**Example - Player Signals:**
```gdscript
# modules/world_player_v2/autoload/player_signals.gd
signal health_changed(current: int, maximum: int)
signal stamina_changed(current: float, maximum: float)
signal died()
signal item_equipped(item_id: String)
signal terrain_modified(position: Vector3, type: String)
```

**Usage:**
```gdscript
# Any component can listen:
PlayerSignals.health_changed.connect(_update_health_ui)

# Any component can emit:
PlayerSignals.health_changed.emit(current_health, max_health)
```

### Resource-Based Data Management

Game data is stored as Resources for easy editing and serialization:

**Item Definition:**
```gdscript
class_name ItemData extends Resource
@export var id: String
@export var name: String
@export var description: String
@export var icon: Texture2D
@export var weight: float
@export var max_stack: int
```

**Recipe Definition:**
```gdscript
class_name RecipeData extends Resource
@export var result_item: String
@export var result_count: int
@export var ingredients: Dictionary
@export var craft_time: float
```

### Manager Pattern

World systems use manager singletons accessed via groups:

```gdscript
# Find managers via groups
terrain_manager = get_tree().get_first_node_in_group("terrain_manager")
building_manager = get_tree().get_first_node_in_group("building_manager")
vegetation_manager = get_tree().get_first_node_in_group("vegetation_manager")
```

This provides:
- Loose coupling between systems
- Easy system replacement
- Clear system boundaries
- Simplified testing

## Data Flow

### Player Input Flow
```
Input -> Player Controller -> Feature Systems -> Game State
                    ↓
              Signal Emission
                    ↓
              UI Updates / Audio / Effects
```

### Terrain Modification Flow
```
Player Action -> Terrain Tool -> Terrain Manager -> Chunk Manager
                                          ↓
                                    Mesh Generation
                                          ↓
                                    Collision Update
                                          ↓
                                    Save System
```

### Save/Load Flow
```
Save Request -> Save Manager -> Serializers -> File System
Load Request -> Save Manager -> Deserializers -> Game State
```

## Performance Considerations

### Chunk-Based World Loading
- World divided into chunks for efficient loading
- Only visible chunks are processed
- Chunks can be unloaded when not needed

### GPU Acceleration
- Terrain generation uses C++ extensions
- Greedy meshing runs on GPU
- Collision generation optimized for performance

### Object Pooling
- Frequently created objects use object pools
- Reduces garbage collection overhead
- Improves frame timing consistency

## Development Guidelines

### Adding New Features

1. **Create Feature Folder:**
   ```
   modules/world_player_v2/features/your_feature/
   ├── your_feature.gd
   ├── your_feature.tscn
   └── signals.gd
   ```

2. **Define Signals:**
   ```gdscript
   # signals.gd
   signal your_feature_event(data: Variant)
   ```

3. **Implement Feature:**
   ```gdscript
   # your_feature.gd
   extends Node
   class_name YourFeature

   func _ready() -> void:
       # Initialize feature
       pass

   func your_method() -> void:
       # Feature logic
       YourFeatureSignals.your_feature_event.emit(data)
   ```

4. **Register in Player:**
   ```gdscript
   # player.gd
   var your_feature: Node = null

   func _ready() -> void:
       your_feature = components_node.get_node_or_null("YourFeature")
   ```

### Testing

Use the test bots in `addons/tests/` for automated testing:
- Create focused test bots for specific features
- Use groups for test organization
- Provide clear test output and results

### Debugging

Use the autoloaded debug tools:
- `DebugManager` for global debug control
- `PerformanceMonitor` for profiling
- `CollisionDebugger` for visual collision debugging

## Migration Notes

### Legacy Systems

The project contains legacy code that is being phased out:
- `modules/world_player_legacy/` - Old player implementation
- `modules/world_player_tools/` - Experimental ragdoll system

These systems are kept for reference but should not be used for new development.

### Transition to V2

The player system is transitioning from legacy to V2:
- Use `modules/world_player_v2/` for new player features
- Port useful features from legacy as needed
- Follow the feature-centric architecture pattern

## Future Architecture Plans

### Planned Systems
- **Quest System**: Story and mission management
- **Advanced AI**: Improved enemy behaviors
- **Multiplayer**: Networked gameplay support
- **Mod Support**: Plugin system for extensions

### Architecture Improvements
- **Dependency Injection**: More explicit dependency management
- **Event Sourcing**: Better state management and replay
- **Component-Based ECS**: More flexible entity composition
- **Data-Driven Design**: Increased use of Resources and data files

## References

- **Godot Documentation**: https://docs.godotengine.org/
- **Architecture Suggestions**: `modules/ARCHITECTURE_SUGGESTIONS.md`
- **Terrain Design**: `modules/3d_world_generation_design.md`
- **Visual Options**: `modules/TERRAIN_VISUAL_OPTIONS.md`

---

This architecture document is a living document and will be updated as the project evolves.