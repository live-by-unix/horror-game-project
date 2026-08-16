# Horror Survival Game Project

A first-person sandbox hybrid voxel survival game built with Godot Engine 4.6, featuring advanced terrain generation, survival mechanics, and modular architecture.

## 🎮 Features

### Core Gameplay
- **First-Person Survival**: Immersive FPS-style survival gameplay with resource gathering, crafting, and base building
- **Voxel Terrain System**: Advanced terrain generation using Marching Cubes and Greedy Meshing algorithms
- **Dynamic World**: Procedurally generated environments with vegetation, structures, and interactive objects
- **Combat System**: Fight against zombies and other threats with various weapons and tools
- **Building System**: Construct and customize your base with blocks, furniture, and functional objects
- **Inventory Management**: Comprehensive item system with hotbar, containers, and crafting

### Technical Features
- **Modular Architecture**: Feature-centric design with self-contained modules and decoupled components
- **Performance Optimized**: GPU-accelerated mesh generation and efficient chunk management
- **GDExtension Integration**: C++ extensions for performance-critical systems
- **Signal-Based Communication**: Decoupled component interaction using Godot's signal system
- **Save/Load System**: Persistent world state with container registry and save management
- **Debug Tools**: Comprehensive debugging suite with performance monitoring and collision debugging

## 🚀 Quick Start

### Prerequisites
- **Godot Engine 4.6+** with Forward Plus renderer
- **NVIDIA GeForce GTX 1060** or equivalent (minimum requirement)
- **Platform**: Windows, macOS, or Linux

### Installation
1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/horror-survival-game-project.git
   cd horror-survival-game-project
   ```

2. Open the project in Godot 4.6:
   - Launch Godot Engine
   - Click "Import" and select the `project.godot` file
   - The project will automatically configure itself

3. Run the game:
   - Press F5 in Godot Editor or click the Play button
   - The game includes a compatibility checker for renderer settings

## 📁 Project Structure

```
horror-survival-game-project/
├── addons/              # Godot plugins and extensions
│   ├── performance_monitor/
│   ├── renderer_fallback/
│   └── tests/          # Automated test bots
├── game/                # Core game systems
│   ├── entities/        # Entity system (zombies, etc.)
│   └── sound/          # Audio management
├── modules/             # Feature modules
│   ├── debug_module/    # Debug tools
│   ├── world_player_v2/ # Player system (current)
│   ├── world_player_legacy/ # Legacy player code
│   └── world_generation/ # Terrain generation
├── models/              # 3D assets and models
├── save_manager/        # Save/load system
├── world_building_system/ # Construction system
├── world_editor/        # World editing tools
├── world_greedy_meshing/ # Mesh optimization
├── world_marching_cubes/ # Terrain generation
├── world_prefabs/       # Prefab system
├── world_vegetation/    # Plant and tree system
├── world_vehicles/      # Vehicle system
└── world_voxel_brush/   # Terrain modification tools
```

## 🏗️ Architecture

The project follows a **feature-centric modular architecture**:

### Core Principles
1. **Organize by Feature** - Group by meaning, not file type
2. **Self-Contained Modules** - Each folder has everything it needs
3. **Signals for Communication** - Decoupled components
4. **Custom Resources for Data** - Items, recipes, stats as Resources
5. **Autoloads for Global Access** - Game manager, event bus, save system

### Key Systems

#### Player System (WorldPlayerV2)
The player system is built as a feature-centric coordinator:
- **Body Features**: Movement, camera, stats
- **Tool Features**: Combat, building, interaction, terrain modification
- **Data Features**: Inventory, containers, pickups
- **UI Features**: HUD, loading screen, mode management

#### Terrain Generation
- **Marching Cubes**: Smooth terrain generation algorithm
- **Greedy Meshing**: Optimized mesh generation for performance
- **Chunk Management**: Efficient world loading and streaming
- **Material Registry**: Terrain texture and material system

#### Building System
- **Block Placement**: Grid-based construction
- **Prefab System**: Save and load building templates
- **Object Registry**: Managed placement of interactive objects
- **Physics Integration**: Realistic object physics and collision

## 🎯 Development Status

### Current Focus
- ✅ **Player V2 System**: Feature-centric player implementation
- ✅ **Terrain Generation**: Marching cubes and greedy meshing
- ✅ **Building System**: Basic construction and prefab saving
- ✅ **Combat System**: Weapons, tools, and enemy interaction
- ✅ **Inventory System**: Hotbar, containers, and item management
- 📋 **Story Elements**: Narrative content (planned)

### Known Issues
See `lasting_notes.txt` for current development notes and known issues.

## 🛠️ Development

### Building from Source
This project uses GDExtension for performance-critical systems. To build extensions:

1. Ensure you have the Godot C++ SDK
2. Navigate to the `gdextension/` directory
3. Follow the build instructions for your platform
4. Copy compiled binaries to the appropriate directories

### Testing
The project includes automated test bots in `addons/tests/`:
- `minimal_bot.gd` - Basic functionality tests
- `simple_movement_bot.gd` - Movement system tests
- `zombie_count_bot.gd` - Entity system tests
- `terrain_persistence_test_bot.gd` - Save/load tests

Run tests through the Godot Editor or command line.

### Debug Tools
Enable debug features through autoloaded singletons:
- **DebugManager**: Global debug control
- **PerformanceMonitor**: FPS and memory profiling
- **CollisionDebugger**: Visual collision debugging

## 📖 Documentation

- **Architecture**: See `modules/ARCHITECTURE_SUGGESTIONS.md` for detailed architecture documentation
- **Terrain Design**: See `modules/3d_world_generation_design.md` for terrain generation details
- **Visual Options**: See `modules/TERRAIN_VISUAL_OPTIONS.md` for rendering options
- **API Documentation**: See individual module files for inline documentation

## 🤝 Contributing

This is an open-source project under CC0 license. Contributions are welcome!

### Development Guidelines
- Follow the feature-centric architecture pattern
- Use signals for component communication
- Keep modules self-contained
- Add inline documentation for new features
- Test thoroughly before submitting changes

### Code Style
- Use GDScript typing for better performance
- Follow Godot naming conventions
- Organize code by feature, not file type
- Use autoloads sparingly and appropriately

## 📜 License

This project is released under the **Creative Commons CC0 1.0 Universal** license.

This means:
- ✅ Free to use for any purpose
- ✅ Free to modify and distribute
- ✅ Commercial use allowed
- ✅ No attribution required (but appreciated)

See [LICENSE](LICENSE) for the full legal text.

## 🙏 Credits

### Project Author
- **BoQsc** - Original project creator (2025)
- **live-by-unix** - Project refinement and editing

### Asset Credits
See [credits.txt](credits.txt) for detailed attribution of all third-party assets including:
- 3D models (Sketchfab artists)
- Audio effects (Pixabay, Freesound artists)
- Textures and materials

### Technology
- **Godot Engine 4.6** - Game engine
- **Marching Cubes Algorithm** - Terrain generation
- **Greedy Meshing** - Mesh optimization
- **GDExtension** - C++ integration

## 📞 Support

For issues, questions, or contributions:
- Check existing documentation in the `docs/` folder
- Review architecture suggestions in `modules/ARCHITECTURE_SUGGESTIONS.md`
- Examine inline code documentation
- Review test bots for usage examples

## 🔮 Roadmap

### Short Term
- Complete player V2 transition
- Implement full save/load system
- Performance optimization
- Enhanced building system

### Medium Term
- Story and quest system
- Advanced AI behaviors
- Multiplayer support
- Additional biomes and environments

### Long Term
- Mod support system
- Procedural quest generation
- Advanced weather and seasons
- Vehicle system expansion

---

**Note**: This project is actively developed. Features and architecture may evolve. Check back regularly for updates!
