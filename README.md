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

#### Admin Chat & Communication Features
- **Admin Chat** - Use `@ <message>` to send messages to all staff members
- **Silent Commands** - Use `$ <command>` to execute commands without broadcasting to other admins (superadmin/admin only)
- **Admin Action Logs** - All admin actions are automatically broadcast to staff members in real-time

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

Edit `lua/sovereign/config/sh_config.lua` to customize:
- Command prefix (default: `!`)
- Authorized user groups
- Database settings (MySQL or SQLite)
- Ban durations
- Logging options
- Advert messages and intervals

Additional configuration files:
- `sh_adminmode.lua` - Admin mode settings (model, sounds, stats)
- `sh_limits.lua` - Sandbox spawn limits per usergroup
- `sh_localization.lua` - Multi-language support
- `sh_roles.lua` - Role hierarchy and permissions

## Folder Structure

```
lua/
├── autorun/
│   └── sovereign_loader.lua          # Main entry point
└── sovereign/
    ├── sh_init.lua                    # Initialization script
    ├── config/                        # Configuration files
    │   ├── sh_config.lua              # Main settings
    │   ├── sh_adminmode.lua           # Admin mode configuration
    │   ├── sh_limits.lua              # Sandbox spawn limits
    │   ├── sh_localization.lua        # Multi-language support
    │   └── sh_roles.lua               # Role management
    ├── core/                          # Core system files
    │   ├── sh_core.lua                # Core functionality
    │   ├── sh_helpers.lua             # Helper utilities
    │   └── sh_compat.lua              # Compatibility layer
    ├── commands/                      # Command implementations
    │   ├── sv_admin.lua               # Admin mode & role commands
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

## Advanced Features

### Admin Mode System
Toggle admin mode with `!adminmode` or a configurable key bind (F2 by default):
- Switches to configurable admin model
- Enables god mode and adjusts stats
- Plays sounds on activation/deactivation
- Integrates with DarkRP job switching
- Remembers previous state when toggling off

### Multi-Role System
Players can have unlimited roles with permission aggregation:
- Use `!addrole <player> <role>` to add roles
- Use `!removerole <player> <role>` to remove roles
- Use `!listroles [player]` to view roles
- Permissions aggregate across all assigned roles
- Roles persist across server restarts

### Compatibility
- **CAMI Support**: Harmonizes with external admin mods
- **bLogs/mLogs Integration**: All actions are automatically logged
- **DarkRP Admin-Job Switching**: Smooth toggling between admin and player jobs
- **UI-Ready Hooks**: Placeholders for future GUI integration

## Role System

Sovereign uses a flexible role system with inheritance:
- **superadmin** - Full access (only default role)
- Additional roles can be added dynamically using `!addrole`
- Supports custom roles: admin, mod, vip, trusted, user
- Multi-role assignments per player
- Role inheritance for permission aggregation

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
- In-game GUI menu (hooks ready for implementation)
- Advanced analytics
- Custom punishment presets
- Extended CAMI integration

## License

This project is open source and available for use and modification.

## Credits

Inspired by ULX, SAM, and xAdmin admin systems.