# Sovereign Commands Reference

## Command Format
All commands use the prefix `!` by default (configurable in `core/sh_config.lua`).

Format: `!command <required_argument> [optional_argument]`

---

## Fun Commands

### freeze
**Usage:** `!freeze <player>`  
**Permission:** admin, mod  
**Description:** Freeze a player in place, preventing movement.  
**Example:** `!freeze John`

### unfreeze
**Usage:** `!unfreeze <player>`  
**Permission:** admin, mod  
**Description:** Unfreeze a frozen player.  
**Example:** `!unfreeze John`

### slap
**Usage:** `!slap <player> [damage]`  
**Permission:** admin, mod  
**Description:** Slap a player, launching them into the air with optional damage.  
**Example:** `!slap John 10`

### ignite
**Usage:** `!ignite <player> [duration]`  
**Permission:** admin  
**Description:** Set a player on fire for a specified duration (default: 10 seconds).  
**Example:** `!ignite John 15`

### extinguish
**Usage:** `!extinguish <player>`  
**Permission:** admin, mod  
**Description:** Extinguish a burning player.  
**Example:** `!extinguish John`

---

## Moderation Commands

### ban
**Usage:** `!ban <player> <duration> [reason]`  
**Permission:** superadmin, admin  
**Description:** Ban a player from the server. Duration in minutes (0 = permanent).  
**Example:** `!ban John 1440 Griefing` (24 hour ban)

### unban
**Usage:** `!unban <steamid>`  
**Permission:** superadmin, admin  
**Description:** Remove a ban by SteamID.  
**Example:** `!unban STEAM_0:1:12345678`

### kick
**Usage:** `!kick <player> [reason]`  
**Permission:** admin, mod  
**Description:** Kick a player from the server.  
**Example:** `!kick John Spamming chat`

### warn
**Usage:** `!warn <player> [reason]`  
**Permission:** admin, mod  
**Description:** Issue a warning to a player (logged in database).  
**Example:** `!warn John Breaking server rules`

### slay
**Usage:** `!slay <player>`  
**Permission:** admin  
**Description:** Instantly kill a player.  
**Example:** `!slay John`

---

## Teleportation Commands

### goto
**Usage:** `!goto <player>`  
**Permission:** admin, mod  
**Description:** Teleport to a player's location. Saves your position for `!return`.  
**Example:** `!goto John`

### bring
**Usage:** `!bring <player>`  
**Permission:** admin, mod  
**Description:** Bring a player to your location. Saves their position for `!return`.  
**Example:** `!bring John`

### return
**Usage:** `!return [player]`  
**Permission:** admin, mod  
**Description:** Return yourself or another player to their previous location.  
**Example:** `!return` or `!return John`

### tp
**Usage:** `!tp <x> <y> <z>`  
**Permission:** admin  
**Description:** Teleport to specific coordinates.  
**Example:** `!tp 0 0 64`

### send
**Usage:** `!send <player> <destination>`  
**Permission:** admin  
**Description:** Send one player to another player's location.  
**Example:** `!send John Jane`

---

## Utility Commands

### noclip
**Usage:** `!noclip [player]`  
**Permission:** admin, mod  
**Description:** Toggle noclip mode for yourself or another player.  
**Example:** `!noclip` or `!noclip John`

### cloak
**Usage:** `!cloak [player]`  
**Permission:** admin, mod  
**Description:** Make yourself or another player invisible.  
**Example:** `!cloak` or `!cloak John`

### uncloak
**Usage:** `!uncloak [player]`  
**Permission:** admin, mod  
**Description:** Make yourself or another player visible again.  
**Example:** `!uncloak` or `!uncloak John`

### god
**Usage:** `!god [player]`  
**Permission:** admin  
**Description:** Enable god mode (invincibility) for yourself or another player.  
**Example:** `!god` or `!god John`

### ungod
**Usage:** `!ungod [player]`  
**Permission:** admin  
**Description:** Disable god mode for yourself or another player.  
**Example:** `!ungod` or `!ungod John`

### hp
**Usage:** `!hp <player> [amount]`  
**Permission:** admin, mod  
**Description:** Set a player's health (default: 100).  
**Example:** `!hp John 200`

### armor
**Usage:** `!armor <player> [amount]`  
**Permission:** admin, mod  
**Description:** Set a player's armor (default: 100).  
**Example:** `!armor John 150`

### strip
**Usage:** `!strip <player>`  
**Permission:** admin  
**Description:** Remove all weapons from a player.  
**Example:** `!strip John`

### respawn
**Usage:** `!respawn <player>`  
**Permission:** admin, mod  
**Description:** Respawn a dead player.  
**Example:** `!respawn John`

---

## Permission Levels

Commands are restricted by role with inheritance:

- **superadmin** - All commands
- **admin** - All commands except unban
- **mod** - Basic moderation and fun commands
- **user** - No admin commands

Roles inherit permissions from lower roles (e.g., admin can use all mod commands).

---

## Tips

1. You can use partial player names (e.g., `!freeze jo` for "John")
2. All commands are logged in the database
3. Multiple word reasons don't need quotes: `!ban John 60 Being rude in chat`
4. Use `!return` after teleporting to go back to your original position
5. Some commands work on yourself if no player is specified (e.g., `!noclip`)
