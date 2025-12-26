# Sovereign - Garry's Mod Admin System

A lightweight, modular, command-based admin system for Garry's Mod servers.

## Features

### Command Categories

#### Fun Commands (11 commands)
- `!freeze <player>` - Freeze a player in place
- `!unfreeze <player>` - Unfreeze a frozen player
- `!jail <player> [duration]` - Jail a player with a physical jail prop
- `!unjail <player>` - Unjail a jailed player
- `!slap <player> [damage]` - Slap a player with optional damage
- `!ignite <player> [duration]` - Set a player on fire
- `!extinguish <player>` - Extinguish a burning player
- `!exitvehicle <player>` - Force a player to exit their vehicle
- `!giveammo <player> <type> [amount]` - Give ammunition to a player
- `!setmodel <player> <model>` - Change a player's model
- `!scale <player> <scale>` - Change a player's size

#### Chat Commands (6 commands)
- `!pm <player> <message>` - Send a private message to a player
- `!asay <message>` - Send a message to all admins
- `!mute <player> [duration]` - Mute a player's voice chat
- `!unmute <player>` - Unmute a player's voice chat
- `!gag <player> [duration]` - Gag a player's text chat
- `!ungag <player>` - Ungag a player's text chat

#### Moderation Commands (8 commands)
- `!ban <player> <duration> [reason]` - Ban a player from the server
- `!banid <steamid> <duration> [reason]` - Ban a player by SteamID
- `!unban <steamid>` - Unban a player by SteamID
- `!kick <player> [reason]` - Kick a player from the server
- `!warn <player> [reason]` - Warn a player
- `!slay <player>` - Kill a player instantly
- `!setrank <player> <rank>` - Set a player's rank/usergroup
- `!setrankid <steamid> <rank>` - Set rank by SteamID (works offline)
- `!removeuser <steamid>` - Remove a user from the database

#### Teleportation Commands (5 commands)
- `!goto <player>` - Teleport to a player
- `!bring <player>` - Bring a player to you
- `!return [player]` - Return to previous location or return a player
- `!tp <x> <y> <z>` - Teleport to specific coordinates
- `!send <player> <destination>` - Send one player to another

#### Utility Commands (17 commands)
- `!noclip [player]` - Toggle noclip mode
- `!cloak [player]` - Make a player invisible
- `!uncloak [player]` - Make a cloaked player visible
- `!god [player]` - Enable god mode (invincibility)
- `!ungod [player]` - Disable god mode
- `!hp <player> [amount]` - Set a player's health
- `!armor <player> [amount]` - Set a player's armor
- `!strip <player>` - Remove all weapons from a player
- `!respawn <player>` - Respawn a player
- `!stopsound [player]` - Stop all sounds for a player
- `!cleardecals [player]` - Clear decals for a player
- `!map <mapname>` - Change the server map
- `!maprestart [delay]` - Restart the current map
- `!mapreset` - Reset all map entities
- `!give <player> <weapon/entity>` - Give a weapon or entity
- `!time <player>` - Show player's current session playtime
- `!totaltime <player>` - Show player's total playtime

#### DarkRP Commands (8 commands)
- `!arrest <player> [duration]` - Arrest a player
- `!unarrest <player>` - Unarrest a player
- `!setmoney <player> <amount>` - Set a player's money
- `!addmoney <player> <amount>` - Add money to a player
- `!selldoor <player>` - Sell a player's door
- `!sellall <player>` - Sell all doors owned by a player
- `!setjailpos` - Set jail spawn position
- `!addjailpos` - Add jail spawn position

**Total: 55+ Commands**

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
    │   ├── sv_utility.lua             # Utility commands
    │   ├── sv_chat.lua                # Chat commands
    │   └── sv_darkrp.lua              # DarkRP-specific commands
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
- Tracks player playtime
- Stores user ranks and permissions
- Saves jail spawn positions
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