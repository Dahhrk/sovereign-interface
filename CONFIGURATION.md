# Configuration Guide

This guide explains how to configure the Sovereign Admin System.

## Main Configuration File

Edit `lua/sovereign/core/sh_config.lua` to customize the system.

### Command Prefix

```lua
Sovereign.Config.Prefix = "!"
```

Change this to any prefix you prefer (e.g., `/`, `.`, `#`).

### Authorized Groups

```lua
Sovereign.Config.AuthorizedGroups = { "admin", "superadmin", "mod" }
```

List of usergroups that have access to admin commands.

### Command Cooldown

```lua
Sovereign.Config.CommandCooldown = 0.5
```

Minimum time (in seconds) between command executions to prevent spam.

### Enable Logging

```lua
Sovereign.Config.EnableLogging = true
```

Set to `false` to disable command logging in the database.

---

## Database Configuration

### Using SQLite (Default)

```lua
Sovereign.Config.Database = {
    Type = "sqlite",
    SQLite = {
        Path = "sovereign.db"
    }
}
```

SQLite is recommended for small to medium servers. No additional setup required.

### Using MySQL

```lua
Sovereign.Config.Database = {
    Type = "mysql",
    MySQL = {
        Host = "localhost",
        Port = 3306,
        Username = "your_username",
        Password = "your_password",
        Database = "sovereign"
    }
}
```

**Requirements:**
- Install the MySQLOO module on your server
- Create a database named "sovereign" (or your chosen name)
- Ensure the user has CREATE, INSERT, UPDATE, DELETE, and SELECT privileges

---

## Ban Duration Presets

```lua
Sovereign.Config.BanDurations = {
    short = 60,      -- 1 hour
    medium = 1440,   -- 24 hours
    long = 10080,    -- 1 week
    permanent = 0    -- 0 = permanent
}
```

These are reference values. When using the `!ban` command, specify the duration in minutes.

---

## Role Configuration

Edit `lua/sovereign/core/sh_roles.lua` to modify the role hierarchy.

### Default Role Hierarchy

```lua
Sovereign.Roles.Hierarchy = {
    superadmin = { inherit = { "admin" } },
    admin = { inherit = { "mod" } },
    mod = { inherit = { "user" } },
    user = {}
}
```

### Adding a New Role

To add a new role between admin and mod:

```lua
Sovereign.Roles.Hierarchy = {
    superadmin = { inherit = { "admin" } },
    admin = { inherit = { "trusted" } },  -- Changed
    trusted = { inherit = { "mod" } },     -- New role
    mod = { inherit = { "user" } },
    user = {}
}
```

Then update command permissions in the command files to include the new role.

### Modifying Command Permissions

Edit the command files in `lua/sovereign/commands/` and change the roles array:

```lua
-- Before (admin and mod only)
Sovereign.RegisterCommand("freeze", { "admin", "mod" }, function(admin, args)
    -- command code
end)

-- After (admin, trusted, and mod)
Sovereign.RegisterCommand("freeze", { "admin", "trusted", "mod" }, function(admin, args)
    -- command code
end)
```

---

## Theme Configuration

Edit `lua/sovereign/ui/themes/cl_theme_base.lua` to customize the UI theme (for future UI implementation).

### Color Scheme

```lua
Sovereign.Theme.Colors = {
    Primary = Color(41, 128, 185),      -- Blue
    Secondary = Color(52, 73, 94),      -- Dark Blue-Gray
    Success = Color(39, 174, 96),       -- Green
    Warning = Color(243, 156, 18),      -- Orange
    Danger = Color(231, 76, 60),        -- Red
    
    Background = Color(30, 30, 30),     -- Dark Background
    BackgroundLight = Color(45, 45, 45), -- Lighter Background
    
    Text = Color(236, 240, 241),        -- Light Text
    TextDark = Color(127, 140, 141),    -- Darker Text
    
    Border = Color(52, 73, 94),         -- Border Color
}
```

---

## Server Setup

### Setting User Roles

Users get roles through your server's user management system. For ULX:

```
ulx adduser <player> <group>
```

For ServerGuard:

```
sg adduser <player> <group>
```

Or manually in `settings/users.txt` for basic Garry's Mod:

```
"UserID" "UserGroup"
"STEAM_0:1:12345678" "admin"
```

### Reloading Configuration

After making changes to configuration files:

1. Change the map: `changelevel gm_construct`
2. Or restart the server

Note: Some changes may require a full server restart.

---

## Advanced Configuration

### Custom Command Creation

To add a custom command, create a new file in `lua/sovereign/commands/` or add to an existing one:

```lua
Sovereign.RegisterCommand("mycommand", { "admin" }, function(admin, args)
    local targetName = args[1]
    
    if not targetName then
        Sovereign.NotifyPlayer(admin, "Usage: !mycommand <player>")
        return
    end
    
    local target = Sovereign.GetPlayerByName(targetName)
    if not IsValid(target) then
        Sovereign.NotifyPlayer(admin, "Player not found: " .. targetName)
        return
    end
    
    -- Your command logic here
    
    Sovereign.NotifyPlayer(admin, "Command executed successfully!")
end, "Description of your command")
```

Then add the file to `lua/sovereign/sh_init.lua`:

```lua
include("sovereign/commands/sv_mycommands.lua")
```

---

## Troubleshooting

### Commands not working
- Check console for errors
- Verify your usergroup is in `AuthorizedGroups`
- Ensure you're using the correct prefix

### Database errors
- For MySQL: Check credentials and MySQLOO installation
- For SQLite: Check file permissions in the data folder

### Player lookup issues
- Use partial names if full names don't work
- Names are case-insensitive
- Special characters in names may cause issues

---

## Security Recommendations

1. **Use strong passwords** for MySQL databases
2. **Limit superadmin** to only trusted individuals
3. **Enable logging** to track admin actions
4. **Regular backups** of the database
5. **Review logs** periodically for abuse

---

## Performance Tips

1. Use SQLite for servers with <50 players
2. Use MySQL for larger servers or multi-server setups
3. Adjust `CommandCooldown` to prevent command spam
4. Regularly clean old logs from the database
