# Quick Start Guide - Sovereign Admin System

## Installation (1 minute)

1. Download/clone this repository
2. Place the `lua/` folder in `garrysmod/addons/sovereign/`
3. Restart your Garry's Mod server
4. Done! Commands are ready to use

## First Commands to Try

```
!freeze john          - Freeze player "john"
!unfreeze john        - Unfreeze player
!goto john            - Teleport to player
!bring john           - Bring player to you
!noclip               - Toggle your noclip
```

## Default Setup

- **Prefix:** `!` (type `!command` in chat)
- **Database:** SQLite (automatic, no setup needed)
- **Roles:** Uses your server's usergroup system

## Who Can Use What?

| Role        | Can Use                                      |
|-------------|----------------------------------------------|
| superadmin  | All 28 commands                              |
| admin       | Most commands (freeze, ban, god, teleport)   |
| mod         | Basic commands (freeze, kick, warn, noclip)  |
| user        | No admin commands                            |

## Most Used Commands

### Moderation
```
!ban <player> <minutes> [reason]    - Ban someone
!kick <player> [reason]             - Kick someone
!warn <player> [reason]             - Warn someone
```

### Teleportation
```
!goto <player>                      - Go to player
!bring <player>                     - Bring to you
!return                             - Go back
```

### Utility
```
!noclip [player]                    - Toggle noclip
!god [player]                       - Toggle god mode
!hp <player> <amount>               - Set health
```

### Fun
```
!freeze <player>                    - Freeze player
!slap <player> [damage]             - Slap player
!ignite <player> [seconds]          - Set on fire
```

## Configuration (Optional)

Edit `lua/sovereign/core/sh_config.lua` to change:

### Change Command Prefix
```lua
Sovereign.Config.Prefix = "/"  -- Use /command instead of !command
```

### Use MySQL Instead of SQLite
```lua
Sovereign.Config.Database = {
    Type = "mysql",
    MySQL = {
        Host = "localhost",
        Username = "your_user",
        Password = "your_pass",
        Database = "sovereign"
    }
}
```

## Troubleshooting

### Commands not working?
- Make sure you're an admin: `ulx adduser YourName admin`
- Check the prefix - default is `!`
- Look for errors in server console

### Can't find player?
- Try partial name: `!freeze jo` instead of `!freeze john`
- Names are case-insensitive
- Player must be online

### Database errors?
- SQLite works automatically
- For MySQL: Install MySQLOO module
- Check console for specific errors

## Getting Help

1. **Commands:** See `COMMANDS.md` for all 28 commands
2. **Setup:** See `CONFIGURATION.md` for detailed config
3. **Testing:** See `TESTING.md` for validation steps
4. **Security:** See `SECURITY.md` for security info

## Common Tasks

### Add someone as admin
```
ulx adduser PlayerName admin
```

### Ban someone for 24 hours
```
!ban PlayerName 1440 Breaking rules
```

### Check who's banned
```lua
lua_run PrintTable(sql.Query("SELECT * FROM sovereign_bans"))
```

### View recent commands
```lua
lua_run PrintTable(sql.Query("SELECT * FROM sovereign_logs ORDER BY timestamp DESC LIMIT 10"))
```

### Unban someone
```
!unban STEAM_0:1:12345678
```

## Key Features

✓ **28 Commands** - Everything you need for server management  
✓ **Role System** - Automatic permission inheritance  
✓ **Database** - Bans, warnings, and logs stored automatically  
✓ **Partial Names** - Find players easily  
✓ **Smart Teleport** - Return to where you were  
✓ **Safe** - SQL injection protected, permission checked  

## What's Next?

The system is fully functional as-is. Future updates may include:
- In-game GUI menu
- Web admin panel
- Advanced analytics
- Custom presets

But everything works perfectly via commands right now!

## Quick Reference Card

```
MODERATION          TELEPORTATION       UTILITY
!ban                !goto               !noclip
!unban              !bring              !god
!kick               !return             !cloak
!warn               !tp                 !hp
!slay               !send               !armor

FUN COMMANDS        DATABASE            ROLES
!freeze             SQLite auto         superadmin
!unfreeze           MySQL optional      admin
!slap               Ban tracking        mod
!ignite             Warn system         user
!extinguish         Full logging        (inherits)
```

## Support

- Check console for error messages
- All actions are logged in the database
- Commands auto-complete with partial names
- Permissions are checked automatically

---

**That's it! You're ready to manage your server with Sovereign.**

Type `!freeze <player>` in chat to try your first command!
