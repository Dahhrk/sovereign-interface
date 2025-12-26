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

### jail
**Usage:** `!jail <player> [duration]`  
**Permission:** admin, mod  
**Description:** Jail a player with a physical jail prop. Duration in seconds (0 = permanent).  
**Example:** `!jail John 60`

### unjail
**Usage:** `!unjail <player>`  
**Permission:** admin, mod  
**Description:** Unjail a jailed player.  
**Example:** `!unjail John`

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

### exitvehicle
**Usage:** `!exitvehicle <player>`  
**Permission:** admin, mod  
**Description:** Force a player to exit their vehicle.  
**Example:** `!exitvehicle John`

### giveammo
**Usage:** `!giveammo <player> <ammotype> [amount]`  
**Permission:** admin  
**Description:** Give ammunition to a player. Default amount is 100.  
**Example:** `!giveammo John pistol 50`

### setmodel
**Usage:** `!setmodel <player> <model>`  
**Permission:** admin  
**Description:** Change a player's model.  
**Example:** `!setmodel John models/player/police.mdl`

### scale
**Usage:** `!scale <player> <scale>`  
**Permission:** admin  
**Description:** Change a player's size scale.  
**Example:** `!scale John 2`

---

## Chat Commands

### pm
**Usage:** `!pm <player> <message>`  
**Permission:** admin, mod  
**Description:** Send a private message to a player.  
**Example:** `!pm John Please follow server rules`

### asay
**Usage:** `!asay <message>`  
**Permission:** admin, mod  
**Description:** Send a message to all online admins.  
**Example:** `!asay Need help with player report`

### mute
**Usage:** `!mute <player> [duration]`  
**Permission:** admin, mod  
**Description:** Mute a player's voice chat. Duration in seconds (0 = permanent).  
**Example:** `!mute John 60`

### unmute
**Usage:** `!unmute <player>`  
**Permission:** admin, mod  
**Description:** Unmute a player's voice chat.  
**Example:** `!unmute John`

### gag
**Usage:** `!gag <player> [duration]`  
**Permission:** admin, mod  
**Description:** Gag a player's text chat. Duration in seconds (0 = permanent).  
**Example:** `!gag John 60`

### ungag
**Usage:** `!ungag <player>`  
**Permission:** admin, mod  
**Description:** Ungag a player's text chat.  
**Example:** `!ungag John`

---

## Moderation Commands

**Note:** When `RestrictCommands` is enabled in `sh_adminmode.lua`, most moderation commands require Admin Mode to be active. Use `!adminmode` to toggle Admin Mode before using these commands.

### ban
**Usage:** `!ban <player> <duration> [reason]`  
**Permission:** superadmin, admin  
**Description:** Ban a player from the server. Duration in minutes (0 = permanent).  
**Example:** `!ban John 1440 Griefing` (24 hour ban)

### banid
**Usage:** `!banid <steamid> <duration> [reason]`  
**Permission:** superadmin, admin  
**Description:** Ban a player by SteamID directly. Duration in minutes (0 = permanent).  
**Example:** `!banid STEAM_0:1:12345678 1440 Alt account`

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

### setrank
**Usage:** `!setrank <player> <rank>`  
**Permission:** superadmin  
**Description:** Set a player's rank/usergroup.  
**Example:** `!setrank John admin`

### setrankid
**Usage:** `!setrankid <steamid> <rank>`  
**Permission:** superadmin  
**Description:** Set a player's rank by SteamID (works offline).  
**Example:** `!setrankid STEAM_0:1:12345678 mod`

### removeuser
**Usage:** `!removeuser <steamid>`  
**Permission:** superadmin  
**Description:** Remove a user's data from the database.  
**Example:** `!removeuser STEAM_0:1:12345678`

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

### stopsound
**Usage:** `!stopsound [player]`  
**Permission:** admin, mod  
**Description:** Stop all sounds for yourself or another player.  
**Example:** `!stopsound` or `!stopsound John`

### cleardecals
**Usage:** `!cleardecals [player]`  
**Permission:** admin, mod  
**Description:** Clear all decals for yourself or another player.  
**Example:** `!cleardecals` or `!cleardecals John`

### map
**Usage:** `!map <mapname>`  
**Permission:** superadmin, admin  
**Description:** Change the server to a different map.  
**Example:** `!map gm_construct`

### maprestart
**Usage:** `!maprestart [delay]`  
**Permission:** superadmin, admin  
**Description:** Restart the current map with optional delay in seconds (default: 3).  
**Example:** `!maprestart 5`

### mapreset
**Usage:** `!mapreset`  
**Permission:** superadmin, admin  
**Description:** Reset all map entities (cleanup).  
**Example:** `!mapreset`

### give
**Usage:** `!give <player> <weapon/entity>`  
**Permission:** admin  
**Description:** Give a weapon or entity to a player.  
**Example:** `!give John weapon_crowbar`

### time
**Usage:** `!time <player>`  
**Permission:** admin, mod  
**Description:** Show a player's current session playtime.  
**Example:** `!time John`

### totaltime
**Usage:** `!totaltime <player>`  
**Permission:** admin, mod  
**Description:** Show a player's total playtime on the server.  
**Example:** `!totaltime John`

---

## DarkRP Commands

### arrest
**Usage:** `!arrest <player> [duration]`  
**Permission:** admin, mod  
**Description:** Arrest a player (DarkRP only). Duration in seconds (default: 120).  
**Example:** `!arrest John 60`

### unarrest
**Usage:** `!unarrest <player>`  
**Permission:** admin, mod  
**Description:** Unarrest a player (DarkRP only).  
**Example:** `!unarrest John`

### setmoney
**Usage:** `!setmoney <player> <amount>`  
**Permission:** admin  
**Description:** Set a player's money (DarkRP only).  
**Example:** `!setmoney John 5000`

### addmoney
**Usage:** `!addmoney <player> <amount>`  
**Permission:** admin  
**Description:** Add money to a player (DarkRP only).  
**Example:** `!addmoney John 1000`

### selldoor
**Usage:** `!selldoor <player>`  
**Permission:** admin, mod  
**Description:** Sell the door you're looking at owned by a player (DarkRP only).  
**Example:** `!selldoor John`

### sellall
**Usage:** `!sellall <player>`  
**Permission:** admin, mod  
**Description:** Sell all doors owned by a player (DarkRP only).  
**Example:** `!sellall John`

### setjailpos
**Usage:** `!setjailpos`  
**Permission:** superadmin, admin  
**Description:** Set the jail spawn position at your current location.  
**Example:** `!setjailpos`

### addjailpos
**Usage:** `!addjailpos`  
**Permission:** superadmin, admin  
**Description:** Add an additional jail spawn position at your current location.  
**Example:** `!addjailpos`

---

## Permission Levels

Commands are restricted by role with inheritance:

- **superadmin** - All commands
- **admin** - All commands except some management commands
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
6. DarkRP commands only work when DarkRP is installed on the server

---

## Admin Mode Commands

### adminmode
**Usage:** `!adminmode`  
**Permission:** superadmin, admin  
**Description:** Toggle admin mode on/off. Switches to admin model, enables god mode, and adjusts stats. When Admin Mode command restrictions are enabled, certain sensitive commands (like ban, kick, warn) require Admin Mode to be active.  
**Example:** `!adminmode`

**Note:** 
- Can also be toggled with F2 key (configurable).
- When `RestrictCommands` is enabled in `sh_adminmode.lua`, you must enable Admin Mode to use restricted commands.
- Provides audio feedback when entering/exiting (configurable sounds).

---

## Role Management Commands

### addrole
**Usage:** `!addrole <player> <role>`  
**Permission:** superadmin  
**Description:** Add a role to a player. Supports multi-role assignments.  
**Available Roles:** superadmin, admin, mod, vip, trusted, user  
**Example:** `!addrole John admin`

### removerole
**Usage:** `!removerole <player> <role>`  
**Permission:** superadmin  
**Description:** Remove a role from a player.  
**Example:** `!removerole John admin`

### listroles
**Usage:** `!listroles [player]`  
**Permission:** superadmin, admin  
**Description:** List all available roles or view a player's assigned roles.  
**Examples:**
- `!listroles` - Shows available roles
- `!listroles John` - Shows John's roles

