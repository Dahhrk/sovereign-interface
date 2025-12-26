# Sovereign - Garry's Mod Admin System

A lightweight, modular, command-based admin system for Garry's Mod servers.

## Features

### Command Categories

#### Fun Commands
- `!freeze <player>` - Freeze a player in place
- `!unfreeze <player>` - Unfreeze a frozen player
- `!slap <player> [damage]` - Slap a player with optional damage
- `!ignite <player> [duration]` - Set a player on fire
- `!extinguish <player>` - Extinguish a burning player

#### Moderation Commands
- `!ban <player> <duration> [reason]` - Ban a player from the server
- `!unban <steamid>` - Unban a player by SteamID
- `!kick <player> [reason]` - Kick a player from the server
- `!warn <player> [reason]` - Warn a player
- `!slay <player>` - Kill a player instantly

#### Teleportation Commands
- `!goto <player>` - Teleport to a player
- `!bring <player>` - Bring a player to you
- `!return [player]` - Return to previous location or return a player
- `!tp <x> <y> <z>` - Teleport to specific coordinates
- `!send <player> <destination>` - Send one player to another

#### Utility Commands
- `!noclip [player]` - Toggle noclip mode
- `!cloak [player]` - Make a player invisible
- `!uncloak [player]` - Make a cloaked player visible
- `!god [player]` - Enable god mode (invincibility)
- `!ungod [player]` - Disable god mode
- `!hp <player> [amount]` - Set a player's health
- `!armor <player> [amount]` - Set a player's armor
- `!strip <player>` - Remove all weapons from a player
- `!respawn <player>` - Respawn a player

## Installation

1. Download or clone this repository
2. Place the `lua/` folder in your server's `garrysmod/addons/sovereign/` directory
3. Restart your server or change the map

## Configuration

Edit `lua/sovereign/core/sh_config.lua` to customize:
- Command prefix (default: `!`)
- Authorized user groups
- Database settings (MySQL or SQLite)
- Ban durations
- Logging options

## Folder Structure

```
lua/
├── autorun/
│   └── sovereign_loader.lua          # Main entry point
└── sovereign/
    ├── sh_init.lua                    # Initialization script
    ├── core/                          # Core system files
    │   ├── sh_config.lua              # Configuration
    │   ├── sh_core.lua                # Core functionality
    │   ├── sh_helpers.lua             # Helper utilities
    │   └── sh_roles.lua               # Role management
    ├── commands/                      # Command implementations
    │   ├── sv_fun.lua                 # Fun commands
    │   ├── sv_moderation.lua          # Moderation commands
    │   ├── sv_teleport.lua            # Teleportation commands
    │   └── sv_utility.lua             # Utility commands
    ├── storage/                       # Database handling
    │   └── sv_database.lua            # SQLite/MySQL wrapper
    └── ui/                            # Future UI components
        ├── README.md                  # UI documentation
        └── themes/
            └── cl_theme_base.lua      # Theme definitions
```

## Role System

Sovereign uses a hierarchical role system with inheritance:
- **superadmin** - Full access (inherits from admin)
- **admin** - Most commands (inherits from mod)
- **mod** - Basic moderation commands (inherits from user)
- **user** - Standard player

## Database

Sovereign supports both SQLite (default) and MySQL databases:
- Stores bans with duration and reason
- Logs all command executions
- Records player warnings
- Automatic ban expiration

## Future Features

- Web-based admin panel
- In-game GUI menu
- Advanced permission system
- Player session tracking
- Comprehensive analytics
- Custom punishment presets

## License

This project is open source and available for use and modification.

## Credits

Inspired by ULX, SAM, and xAdmin admin systems.