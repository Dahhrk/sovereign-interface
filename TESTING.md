# Testing Guide for Sovereign Admin System

This guide explains how to test the Sovereign Admin System in a Garry's Mod server environment.

## Prerequisites

1. A Garry's Mod dedicated server or listen server
2. Admin/superadmin privileges on the server
3. At least one other player or bot for testing commands

## Installation for Testing

1. Place the `lua/` folder in your `garrysmod/addons/sovereign/` directory
2. Start or restart your server
3. Check console for initialization messages

## Expected Console Output

On server start, you should see:
```
[Sovereign] Initializing admin system...
[Sovereign] Configuration loaded.
[Sovereign] Helper utilities loaded.
[Sovereign] Role management loaded.
[Sovereign] Core system loaded.
[Sovereign] Using SQLite database.
[Sovereign] SQLite tables created successfully.
[Sovereign] Database system loaded.
[Sovereign] Registered command: freeze
[Sovereign] Registered command: unfreeze
... (all commands)
[Sovereign] Fun commands loaded.
[Sovereign] Moderation commands loaded.
[Sovereign] Teleport commands loaded.
[Sovereign] Utility commands loaded.
[Sovereign] Admin system loaded successfully!
[Sovereign] Command prefix: !
[Sovereign] Total commands registered: 28
[Sovereign] Server-side initialized.
```

## Basic Functionality Tests

### 1. Test Command Registration

Open console and verify commands are registered:
```lua
lua_run PrintTable(Sovereign.Commands)
```

You should see all 28 commands listed.

### 2. Test Permission System

As an admin, try a command:
```
!freeze <playername>
```

As a non-admin, the same command should fail with:
```
[Sovereign] You don't have permission to use this command.
```

### 3. Test Player Lookup

Test with full name:
```
!freeze John
```

Test with partial name:
```
!freeze jo
```

Both should work if a player named "John" is present.

### 4. Test Fun Commands

```
!freeze <player>      - Player should be unable to move
!unfreeze <player>    - Player should be able to move again
!slap <player> 10     - Player should be launched in air and take 10 damage
!ignite <player> 5    - Player should be set on fire for 5 seconds
!extinguish <player>  - Fire should be extinguished
```

### 5. Test Moderation Commands

```
!warn <player> Testing warning system
!kick <player> Test kick
!ban <player> 5 Test 5 minute ban
!unban STEAM_0:X:XXXXX
```

Check database:
```lua
lua_run PrintTable(sql.Query("SELECT * FROM sovereign_bans"))
lua_run PrintTable(sql.Query("SELECT * FROM sovereign_warnings"))
```

### 6. Test Teleportation Commands

```
!goto <player>        - You should teleport to the player
!return               - You should return to original position
!bring <player>       - Player should teleport to you
!return <player>      - Player should return to original position
!tp 0 0 100          - You should teleport to coordinates
!send <player1> <player2> - Player1 should teleport to Player2
```

### 7. Test Utility Commands

```
!noclip               - You should enter noclip mode
!noclip               - You should exit noclip mode
!god                  - You should become invincible
!hp <player> 200      - Player health should be 200
!armor <player> 150   - Player armor should be 150
!cloak                - You should become invisible
!uncloak              - You should become visible
!strip <player>       - Player's weapons should be removed
!respawn <player>     - Dead player should respawn
```

### 8. Test Role Inheritance

Set up test users with different roles:
```
ulx adduser testmod mod
ulx adduser testadmin admin
ulx adduser testsuperadmin superadmin
```

Test that:
- `mod` can use freeze, unfreeze, slap
- `admin` can use all mod commands + ban, ignite, god
- `superadmin` can use all commands

### 9. Test Database Logging

Execute several commands, then check logs:
```lua
lua_run PrintTable(sql.Query("SELECT * FROM sovereign_logs ORDER BY timestamp DESC LIMIT 10"))
```

You should see all executed commands logged.

### 10. Test Ban System

1. Ban a player:
```
!ban <player> 2 Test ban
```

2. Player should be kicked with ban message

3. Check database:
```lua
lua_run PrintTable(sql.Query("SELECT * FROM sovereign_bans"))
```

4. Try to reconnect - should be denied

5. Unban:
```
!unban STEAM_0:X:XXXXX
```

6. Player should be able to reconnect

## Error Handling Tests

### Test Invalid Arguments

```
!freeze               - Should show usage message
!ban <player>         - Should show usage message
!tp 0 0              - Should show usage message (missing z)
```

### Test Invalid Player Names

```
!freeze nonexistentplayer
```
Should return: `[Sovereign] Player not found: nonexistentplayer`

### Test Self-Targeting Edge Cases

```
!goto <yourself>      - Should show error
!bring <yourself>     - Should show error
```

## Performance Tests

### Command Spam Protection

Rapidly execute commands to test cooldown:
```
!freeze player1
!unfreeze player1
!freeze player1
!unfreeze player1
```

Should respect the `CommandCooldown` setting (0.5 seconds default).

### Database Performance

Execute 100+ commands and verify:
- No lag spikes
- All commands logged correctly
- Database queries complete quickly

```lua
lua_run for i=1,100 do Sovereign.Database.LogAction("STEAM_0:0:0", "test", "args") end
```

## Configuration Tests

### Test Different Prefixes

Edit `lua/sovereign/core/sh_config.lua`:
```lua
Sovereign.Config.Prefix = "/"
```

Restart server. Commands should now use `/` instead of `!`:
```
/freeze <player>
```

### Test MySQL (if available)

Edit config to use MySQL, restart server, verify:
- Connection established
- Tables created
- Commands logged to MySQL database

## Security Tests

### SQL Injection Prevention

Try commands with SQL injection attempts:
```
!ban player'); DROP TABLE sovereign_bans; --
!warn player' OR '1'='1
```

Database should remain intact and queries should be sanitized.

### Permission Bypass Attempts

As non-admin, try:
```lua
lua_run Sovereign.ExecuteCommand(LocalPlayer(), "ban", {"someplayer", "60", "test"})
```

Should still check permissions and deny.

## Cleanup After Testing

```lua
lua_run sql.Query("DELETE FROM sovereign_bans")
lua_run sql.Query("DELETE FROM sovereign_warnings")
lua_run sql.Query("DELETE FROM sovereign_logs")
```

Or delete the database file:
```
data/sovereign.db
```

## Common Issues

### Commands not working
- Check console for errors
- Verify you have correct usergroup
- Check command prefix in config

### Database errors
- Check file permissions in `data/` folder
- Verify SQLite is available: `lua_run print(sql ~= nil)`

### Permission issues
- Verify role inheritance: `lua_run PrintTable(Sovereign.Roles.Hierarchy)`
- Check player usergroup: `lua_run print(LocalPlayer():GetUserGroup())`

## Automated Testing

For automated testing, create a test script:

```lua
-- test_sovereign.lua
local function TestCommand(cmd, args)
    print("[TEST] Executing: " .. cmd .. " with args: " .. table.concat(args, ", "))
    Sovereign.ExecuteCommand(LocalPlayer(), cmd, args)
end

-- Add test suite here
TestCommand("freeze", {"testplayer"})
TestCommand("unfreeze", {"testplayer"})
-- etc.
```

Run with: `lua_run include("test_sovereign.lua")`

## Success Criteria

All tests should pass with:
- ✓ No console errors
- ✓ Commands execute as expected
- ✓ Permissions enforced correctly
- ✓ Database operations successful
- ✓ Role inheritance working
- ✓ Player notifications displayed
- ✓ Actions logged properly

## Reporting Issues

If you find bugs:
1. Note the exact command used
2. Check console for errors
3. Verify database state
4. Check server logs
5. Report with steps to reproduce
