# Getting Started Guide

Welcome to the Horror Survival Game Project! This guide will help you get up and running with the project, whether you're a player wanting to try it out or a developer looking to contribute.

## System Requirements

### Minimum Requirements
- **OS**: Windows 10+, macOS 10.15+, or Linux (Ubuntu 18.04+)
- **Processor**: Modern CPU with SSE4.2 support
- **Graphics**: NVIDIA GeForce GTX 1060 (Max-Q Design) or equivalent
- **Memory**: 8 GB RAM
- **Storage**: 2 GB available space
- **Godot Engine**: Version 4.6 or later

### Recommended Requirements
- **OS**: Windows 11, macOS 12+, or Linux (Ubuntu 20.04+)
- **Processor**: Modern multi-core CPU (Intel i5/i7, AMD Ryzen 5/7)
- **Graphics**: NVIDIA GeForce RTX 2060 or equivalent
- **Memory**: 16 GB RAM
- **Storage**: 5 GB available space (SSD recommended)

## Installation

### Step 1: Install Godot Engine

1. Download Godot Engine 4.6 from the official website: https://godotengine.org/download
2. Choose the standard version (not .NET for this project)
3. Install Godot for your platform:
   - **Windows**: Run the installer
   - **macOS**: Drag the Godot app to your Applications folder
   - **Linux**: Extract the archive and make the binary executable

### Step 2: Clone the Repository

```bash
# Clone the repository
git clone https://github.com/yourusername/horror-survival-game-project.git

# Navigate to the project directory
cd horror-survival-game-project
```

### Step 3: Open the Project in Godot

1. Launch Godot Engine
2. Click the "Import" button in the project manager
3. Navigate to the cloned repository folder
4. Select the `project.godot` file
5. Click "Open & Edit"

Godot will automatically import all assets and configure the project.

## Running the Game

### Method 1: From Godot Editor

1. With the project open in Godot Editor
2. Press `F5` or click the Play button (▶) in the top-right corner
3. The game will launch with the compatibility checker

### Method 2: Exporting a Build

1. In Godot Editor, go to **Project > Export**
2. Add an export preset for your target platform:
   - **Windows Desktop**: Add Windows preset
   - **macOS**: Add macOS preset  
   - **Linux**: Add Linux/X11 preset
3. Configure export settings as needed
4. Click "Export Project" to build the game
5. Run the exported executable

## First Time Setup

### Compatibility Checker

On first launch, the game runs a compatibility checker to ensure your system meets requirements and the renderer is properly configured. This checks:
- GPU capabilities
- Available renderers (Forward Plus, Mobile, Compatibility)
- System performance

If issues are detected, the game will automatically fall back to a compatible renderer.

### Controls

**Default Controls:**
- **WASD** - Movement
- **Mouse** - Look around
- **Space** - Jump
- **Shift** - Sprint
- **E** - Interact with objects
- **T** - Grab physics objects
- **Left Click** - Attack/Use tool
- **Right Click** - Secondary action
- **1-9** - Select hotbar slot
- **Tab** - Open inventory
- **Esc** - Pause menu

**Building Mode:**
- **B** - Toggle build mode
- **Scroll Wheel** - Rotate placement
- **Left Click** - Place block/object
- **Right Click** - Remove block/object

### Basic Gameplay

1. **Movement**: Use WASD to move, mouse to look around
2. **Gathering**: Approach trees/rocks and attack to gather resources
3. **Crafting**: Open inventory (Tab) to craft basic tools
4. **Building**: Press B to enter build mode and construct structures
5. **Survival**: Monitor your health, hunger, and thirst stats

## Project Structure Overview

Understanding the project structure will help you navigate and modify the code:

```
horror-survival-game-project/
├── addons/              # Godot plugins and tools
├── game/                # Core game systems
├── modules/             # Feature modules (main development area)
├── models/              # 3D assets and models
├── save_manager/        # Save/load system
├── world_*/             # World generation systems
└── docs/               # Documentation
```

**Key Areas for Development:**
- `modules/world_player_v2/` - Player system (actively developed)
- `modules/world_generation/` - Terrain generation
- `game/entities/` - Game entities (zombies, etc.)
- `world_building_system/` - Building and construction

## Development Setup

### Setting Up the Development Environment

1. **Godot Editor Configuration:**
   - Open Editor Settings (Editor > Editor Settings)
   - Configure external text editor if preferred
   - Set up version control integration

2. **Project Settings:**
   - Review `project.godot` for project configuration
   - Check input mappings in Project Settings > Input Map
   - Review autoload configuration

3. **Debug Tools:**
   - Enable debug dock in Godot Editor
   - Familiarize yourself with the Performance Monitor
   - Learn to use the Collision Debugger

### Building GDExtensions

The project uses C++ GDExtensions for performance-critical systems:

1. **Install Requirements:**
   - C++ compiler (GCC, Clang, or MSVC)
   - CMake (version 3.16+)
   - Godot C++ SDK

2. **Build Extensions:**
   ```bash
   cd gdextension/
   # Follow build instructions for your platform
   # Copy compiled binaries to appropriate directories
   ```

### Running Tests

The project includes automated test bots:

```bash
# From Godot Editor:
# 1. Open the test scene (e.g., addons/tests/minimal_bot.tscn)
# 2. Press F5 to run the test
# 3. Check output console for results
```

Available test bots:
- `minimal_bot.gd` - Basic functionality
- `simple_movement_bot.gd` - Movement system
- `zombie_count_bot.gd` - Entity system
- `terrain_persistence_test_bot.gd` - Save/load

## Common Tasks

### Adding a New Item

1. Create item definition in `modules/world_player_v2/features/data_inventory/`
2. Add item to item registry
3. Create 3D model in `models/items/`
4. Add item sounds to `game/sound/`
5. Test item functionality

### Modifying Terrain Generation

1. Edit terrain parameters in `modules/world_generation/`
2. Modify density functions in `world_marching_cubes/`
3. Update material registry for new terrain types
4. Test with different world seeds

### Adding Building Blocks

1. Create block definition in `world_building_system/`
2. Add block to object registry
3. Create block model/texture
4. Test placement and physics

### Creating New Enemies

1. Extend `entity_base.gd` in `game/entities/`
2. Implement AI behaviors
3. Create 3D model and animations
4. Add to entity manager spawner

## Troubleshooting

### Common Issues

**Game won't start:**
- Check Godot version is 4.6+
- Verify all assets are imported
- Check console for error messages
- Try running compatibility checker

**Performance issues:**
- Lower graphics settings in Project Settings
- Reduce view distance
- Disable shadows if needed
- Check Performance Monitor for bottlenecks

**Terrain not generating:**
- Verify GDExtension binaries are present
- Check terrain manager is autoloaded
- Review console for C++ extension errors
- Ensure chunk manager is properly initialized

**Controls not working:**
- Check Input Map in Project Settings
- Verify input actions are defined
- Check player controller is active
- Review input processing in player scripts

### Getting Help

If you encounter issues:

1. **Check Documentation:**
   - Read `docs/ARCHITECTURE.md` for system overview
   - Review `modules/ARCHITECTURE_SUGGESTIONS.md` for design patterns
   - Check inline code documentation

2. **Debug Tools:**
   - Enable DebugManager for additional debug info
   - Use PerformanceMonitor to identify bottlenecks
   - Enable CollisionDebugger for physics issues

3. **Community:**
   - Check project issues on GitHub
   - Review existing test bots for examples
   - Examine similar features in the codebase

## Next Steps

### For Players
- Experiment with different game modes
- Try building complex structures
- Explore the world and gather resources
- Test combat against zombies

### For Developers
- Read `docs/ARCHITECTURE.md` for system design
- Examine `modules/world_player_v2/` for player system
- Study test bots for usage examples
- Review `modules/ARCHITECTURE_SUGGESTIONS.md` for patterns

### For Contributors
- Review the code style guidelines
- Understand the feature-centric architecture
- Check existing issues for contribution ideas
- Follow the testing guidelines before submitting

## Additional Resources

### Official Documentation
- **Godot Engine**: https://docs.godotengine.org/
- **GDScript Reference**: https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_basics.html
- **C++ GDExtension**: https://docs.godotengine.org/en/stable/tutorials/scripting/gdextension/what_is_gdextension.html

### Project Documentation
- **Architecture**: `docs/ARCHITECTURE.md`
- **Development Guide**: `docs/DEVELOPMENT.md` (coming soon)
- **Module Documentation**: `docs/MODULES.md` (coming soon)

### External Resources
- **Marching Cubes Algorithm**: Research the algorithm used for terrain generation
- **Greedy Meshing**: Understand the mesh optimization technique
- **Voxel Games**: Study other voxel games for design inspiration

## License and Credits

This project is released under CC0 1.0 Universal license. See [LICENSE](../LICENSE) for details.

For asset credits, see [credits.txt](../credits.txt).

---

**Enjoy exploring and developing with the Horror Survival Game Project!**