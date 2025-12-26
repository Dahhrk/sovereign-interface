# Changelog

All notable changes to the Sovereign Admin System will be documented in this file.

## [1.1.0] - 2025-12-26

### Added

#### Admin Mode Command Restrictions
- **Centralized Command Configuration**: New `sh_commands.lua` file for managing command permissions and admin mode requirements
- **Admin Mode Restrictions**: Commands can now require Admin Mode to be active before execution
- **Configurable Restriction Toggle**: `RestrictCommands` flag in `sh_adminmode.lua` to enable/disable restrictions globally
- **Enhanced Audio Feedback**: Renamed and documented EntrySound and ExitSound in admin mode configuration
- **Security Enhancement**: 11 sensitive commands (ban, kick, warn, etc.) now require Admin Mode when restrictions are enabled
- **User-Friendly Error Messages**: Clear feedback when restricted commands are attempted without Admin Mode

#### Command Configuration
- Centralized command metadata with 61 commands configured
- Each command specifies required roles and admin mode requirement
- Easy customization of which commands require Admin Mode
- Separated restricted (11) and non-restricted (50) commands

### Changed
- Updated `sh_adminmode.lua` with `RestrictCommands` config option
- Enhanced command execution logic in `sh_core.lua` to check admin mode requirements
- Improved documentation in CONFIGURATION.md and COMMANDS.md

### Technical Details
- Added `Sovereign.IsInAdminMode(ply)` helper function for checking admin mode status
- Admin mode restriction check happens after role permission validation
- Full backward compatibility maintained with existing commands
- All validation tests pass

## [1.0.0] - 2025-12-26

### Added

#### Core System
- **Command Registration System**: Centralized system for registering and executing admin commands
- **Role Management**: Hierarchical role system with inheritance (superadmin > admin > mod > user)
- **Permission System**: Command-level permission checking with role validation
- **Helper Utilities**: Common utility functions for time formatting, player lookup, and data management
- **Configuration System**: Centralized configuration for prefix, roles, database, and settings

#### Commands - Fun (5 commands)
- `!freeze <player>` - Freeze a player in place
- `!unfreeze <player>` - Unfreeze a frozen player
- `!slap <player> [damage]` - Slap a player with optional damage
- `!ignite <player> [duration]` - Set a player on fire
- `!extinguish <player>` - Extinguish a burning player

#### Commands - Moderation (5 commands)
- `!ban <player> <duration> [reason]` - Ban a player (with expiration support)
- `!unban <steamid>` - Unban a player by SteamID
- `!kick <player> [reason]` - Kick a player from server
- `!warn <player> [reason]` - Warn a player (stored in database)
- `!slay <player>` - Instantly kill a player

#### Commands - Teleportation (5 commands)
- `!goto <player>` - Teleport to a player
- `!bring <player>` - Bring a player to you
- `!return [player]` - Return to previous location
- `!tp <x> <y> <z>` - Teleport to coordinates
- `!send <player> <destination>` - Send one player to another

#### Commands - Utility (9 commands)
- `!noclip [player]` - Toggle noclip mode
- `!cloak [player]` - Make player invisible
- `!uncloak [player]` - Make player visible
- `!god [player]` - Enable god mode
- `!ungod [player]` - Disable god mode
- `!hp <player> [amount]` - Set player health
- `!armor <player> [amount]` - Set player armor
- `!strip <player>` - Remove all weapons
- `!respawn <player>` - Respawn a player

#### Database System
- **SQLite Support**: Default database using SQLite (no dependencies)
- **MySQL Support**: Optional MySQL support via MySQLOO module
- **Ban Storage**: Persistent ban storage with expiration tracking
- **Warning System**: Player warning storage and tracking
- **Command Logging**: Full audit trail of all admin actions
- **Auto Ban Check**: Automatic ban checking on player connection

#### Features
- **Partial Name Matching**: Find players by partial name
- **Position History**: Save and restore teleport positions
- **Notification System**: In-game notifications for players and admins
- **Error Handling**: Graceful error handling with user-friendly messages
- **Command Cooldown**: Configurable cooldown to prevent spam
- **Logging Toggle**: Enable/disable command logging in configuration

#### Documentation
- `README.md` - Complete feature overview and installation guide
- `COMMANDS.md` - Comprehensive command reference with examples
- `CONFIGURATION.md` - Detailed configuration and setup guide
- `TESTING.md` - Testing procedures and validation steps
- `SECURITY.md` - Security analysis and best practices
- `lua/sovereign/ui/README.md` - UI implementation guidelines

#### Structure
- Organized folder structure with logical separation
- `core/` - Core system files (config, roles, helpers, main)
- `commands/` - Command implementations (fun, moderation, teleport, utility)
- `storage/` - Database handling and persistence
- `ui/` - Future UI components and theming
- Client-side file support (AddCSLuaFile) for future UI

### Technical Details

#### Architecture
- Modular design for easy extension
- Shared/server/client file prefixes (sh_, sv_, cl_)
- Global namespace (Sovereign) to prevent conflicts
- Hook-based command processing via PlayerSay
- pcall() wrapper for command safety

#### Security
- SQL injection prevention (all queries sanitized)
- Permission validation on every command
- Role-based access control with inheritance
- Audit logging for accountability
- Input validation and error handling

#### Compatibility
- Garry's Mod server-side and client-side support
- SQLite (default, no dependencies)
- MySQL (optional, requires MySQLOO)
- Works alongside existing admin systems (ULX, SAM, etc.)

### File Structure
```
lua/
├── autorun/
│   └── sovereign_loader.lua          # System entry point
└── sovereign/
    ├── sh_init.lua                    # Initialization
    ├── core/                          # Core system
    │   ├── sh_config.lua              # Configuration
    │   ├── sh_core.lua                # Main functionality
    │   ├── sh_helpers.lua             # Utilities
    │   └── sh_roles.lua               # Role management
    ├── commands/                      # Commands
    │   ├── sv_fun.lua                 # Fun commands
    │   ├── sv_moderation.lua          # Moderation
    │   ├── sv_teleport.lua            # Teleportation
    │   └── sv_utility.lua             # Utility
    ├── storage/                       # Database
    │   └── sv_database.lua            # SQLite/MySQL
    └── ui/                            # Future UI
        ├── README.md                  # UI docs
        └── themes/
            └── cl_theme_base.lua      # Theme system
```

### Statistics
- **Total Commands**: 28
- **Total Files**: 13 Lua files
- **Lines of Code**: ~1,500+
- **Documentation**: 5 markdown files
- **Database Tables**: 3 (bans, warnings, logs)

### Notes
- System designed for future UI integration
- Command-based interface for immediate usability
- Follows best practices from ULX, SAM, and xAdmin
- Lightweight and performant
- Production-ready with security measures

### Credits
- Architecture inspired by ULX, SAM, and xAdmin
- Built with modularity and extensibility in mind
- Designed for Garry's Mod server administrators

---

## Future Releases

### [1.1.0] - Planned
- In-game GUI menu for command execution
- Player management interface
- Ban/warning viewer with filters
- Real-time server statistics
- Command history browser

### [1.2.0] - Planned
- Web-based admin panel
- Advanced permission customization
- Custom punishment presets
- Player session tracking
- Comprehensive analytics dashboard

### [2.0.0] - Planned
- Full UI implementation
- Multi-server support
- Advanced reporting system
- Plugin API for extensions
- WebSocket support for real-time updates

---

## Version History

- **1.0.0** (2025-12-26) - Initial release with 28 commands, full database support, and comprehensive documentation
