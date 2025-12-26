# Sovereign Admin System - Quick Start Guide

## Installation (5 Minutes)

1. **Download/Clone** this repository
2. **Place** the `lua/` folder in `garrysmod/addons/sovereign/`
3. **Restart** your server or change the map
4. **Grant yourself superadmin**:
   - ULX: `ulx adduser <name> superadmin`
   - ServerGuard: `sg adduser <name> superadmin`
   - Manual: Edit `garrysmod/settings/users.txt`

## Quick Configuration

### Change Command Prefix
Edit `lua/sovereign/config/sh_config.lua`:
```lua
Sovereign.Config.Prefix = "/"  -- Change ! to /
```

### Configure Admin Mode
Edit `lua/sovereign/config/sh_adminmode.lua`:
```lua
Sovereign.Config.AdminMode.Model = "models/player/combine_super_soldier.mdl"
Sovereign.Config.AdminMode.ToggleKey = KEY_F2
```

### Set Spawn Limits
Edit `lua/sovereign/config/sh_limits.lua`:
```lua
Sovereign.Config.Limits.Groups["user"] = {
    props = 50,
    vehicles = 2,
    -- etc.
}
```

## Essential Commands

### Admin Mode
```
!adminmode          - Toggle admin mode on/off
F2                  - Quick toggle (default keybind)
```

### Role Management
```
!addrole John admin       - Add admin role to John
!removerole John admin    - Remove admin role from John
!listroles John           - View John's roles
!listroles                - View all available roles
```

### Player Management
```
!freeze John              - Freeze player
!unfreeze John            - Unfreeze player
!kick John Reason         - Kick player
!ban John 60 Reason       - Ban for 60 minutes
!warn John Reason         - Warn player
```

### Teleportation
```
!goto John                - Go to John
!bring John               - Bring John to you
!return                   - Return to previous location
!tp 0 0 100              - Teleport to coordinates
```

### Utility
```
!noclip                   - Toggle noclip
!god John                 - Give god mode
!cloak John               - Make invisible
!hp John 100             - Set health to 100
!armor John 100          - Set armor to 100
```

## User Roles

### Default Role
- **superadmin** - Only role included by default

### Available Roles (add with !addrole)
- **admin** - Most admin commands
- **mod** - Moderation commands
- **vip** - VIP privileges
- **trusted** - Trusted player
- **user** - Standard player

### Multi-Role Example
```
!addrole John admin      # John gets admin role
!addrole John vip        # John also gets vip role
                         # John now has both admin AND vip permissions
```

## Admin Mode Features

When you toggle admin mode:
- ✓ Model changes to admin model
- ✓ God mode enabled
- ✓ Speed increased
- ✓ Sound plays
- ✓ DarkRP job switches to "Admin on Duty"
- ✓ Previous state saved

When you toggle off:
- ✓ Everything restored
- ✓ Original model back
- ✓ Original job back (DarkRP)
- ✓ Original weapons back

## Validation

Run the validation script to check installation:
```bash
./validate.sh
```

Should output:
```
✓ All checks passed!
Errors: 0
Warnings: 0
```

## Quick Reference Card

```
ADMIN MODE: !adminmode or F2
ROLES:      !addrole, !removerole, !listroles
BAN:        !ban <player> <minutes> [reason]
KICK:       !kick <player> [reason]
FREEZE:     !freeze <player>
TELEPORT:   !goto, !bring, !return, !tp
GOD:        !god <player>
NOCLIP:     !noclip
CLOAK:      !cloak <player>
```

For more details, see:
- `README.md` - Full feature overview
- `CONFIGURATION.md` - Detailed configuration
- `COMMANDS.md` - Complete command reference
- `IMPLEMENTATION.md` - Technical details

Enjoy your new admin system! 🎮
