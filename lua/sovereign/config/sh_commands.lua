-- sh_commands.lua - Centralized command configuration for Sovereign Admin System

Sovereign = Sovereign or {}
Sovereign.Config = Sovereign.Config or {}
Sovereign.Config.Commands = Sovereign.Config.Commands or {}

-- Command configuration with roles and admin mode requirements
-- Format: ["commandName"] = { roles = { "role1", "role2" }, adminMode = true/false }
-- Note: Command names must exactly match those registered via Sovereign.RegisterCommand()
Sovereign.Config.Commands = {
    -- Admin Commands
    ["adminmode"] = { roles = { "superadmin", "admin" }, adminMode = false },
    ["addrole"] = { roles = { "superadmin" }, adminMode = true },
    ["removerole"] = { roles = { "superadmin" }, adminMode = true },
    ["listroles"] = { roles = { "superadmin", "admin" }, adminMode = false },
    
    -- Moderation Commands (require admin mode)
    ["ban"] = { roles = { "superadmin", "admin" }, adminMode = true },
    ["banid"] = { roles = { "superadmin", "admin" }, adminMode = true },
    ["unban"] = { roles = { "superadmin", "admin" }, adminMode = true },
    ["kick"] = { roles = { "admin", "mod" }, adminMode = true },
    ["warn"] = { roles = { "admin", "mod" }, adminMode = true },
    ["slay"] = { roles = { "admin" }, adminMode = true },
    ["setrank"] = { roles = { "superadmin" }, adminMode = true },
    ["setrankid"] = { roles = { "superadmin" }, adminMode = true },
    ["removeuser"] = { roles = { "superadmin" }, adminMode = true },
    
    -- Fun Commands
    ["freeze"] = { roles = { "admin", "mod" }, adminMode = false },
    ["unfreeze"] = { roles = { "admin", "mod" }, adminMode = false },
    ["slap"] = { roles = { "admin", "mod" }, adminMode = false },
    ["ignite"] = { roles = { "admin" }, adminMode = false },
    ["extinguish"] = { roles = { "admin", "mod" }, adminMode = false },
    ["jail"] = { roles = { "admin", "mod" }, adminMode = false },
    ["unjail"] = { roles = { "admin", "mod" }, adminMode = false },
    ["exitvehicle"] = { roles = { "admin", "mod" }, adminMode = false },
    ["giveammo"] = { roles = { "admin" }, adminMode = false },
    ["setmodel"] = { roles = { "admin" }, adminMode = false },
    ["scale"] = { roles = { "admin" }, adminMode = false },
    
    -- Teleport Commands
    ["goto"] = { roles = { "admin", "mod" }, adminMode = false },
    ["bring"] = { roles = { "admin", "mod" }, adminMode = false },
    ["return"] = { roles = { "admin", "mod" }, adminMode = false },
    ["tp"] = { roles = { "admin" }, adminMode = false },
    ["send"] = { roles = { "admin" }, adminMode = false },
    
    -- Utility Commands
    ["noclip"] = { roles = { "admin", "mod" }, adminMode = false },
    ["cloak"] = { roles = { "admin" }, adminMode = false },
    ["uncloak"] = { roles = { "admin" }, adminMode = false },
    ["god"] = { roles = { "admin" }, adminMode = false },
    ["ungod"] = { roles = { "admin" }, adminMode = false },
    ["hp"] = { roles = { "admin" }, adminMode = false },
    ["armor"] = { roles = { "admin" }, adminMode = false },
    ["strip"] = { roles = { "admin" }, adminMode = false },
    ["give"] = { roles = { "admin" }, adminMode = false },
    ["respawn"] = { roles = { "admin", "mod" }, adminMode = false },
    ["cleardecals"] = { roles = { "admin" }, adminMode = false },
    ["mapreset"] = { roles = { "admin" }, adminMode = false },
    ["maprestart"] = { roles = { "admin" }, adminMode = false },
    ["map"] = { roles = { "admin" }, adminMode = false },
    ["stopsound"] = { roles = { "admin", "mod" }, adminMode = false },
    ["time"] = { roles = { "admin", "mod" }, adminMode = false },
    ["totaltime"] = { roles = { "admin", "mod" }, adminMode = false },
    
    -- Chat Commands
    ["pm"] = { roles = { "admin", "mod" }, adminMode = false },
    ["asay"] = { roles = { "admin", "mod" }, adminMode = false },
    ["mute"] = { roles = { "admin", "mod" }, adminMode = false },
    ["unmute"] = { roles = { "admin", "mod" }, adminMode = false },
    ["gag"] = { roles = { "admin", "mod" }, adminMode = false },
    ["ungag"] = { roles = { "admin", "mod" }, adminMode = false },
    
    -- DarkRP Commands
    ["arrest"] = { roles = { "admin", "mod" }, adminMode = false },
    ["unarrest"] = { roles = { "admin", "mod" }, adminMode = false },
    ["setmoney"] = { roles = { "admin" }, adminMode = false },
    ["addmoney"] = { roles = { "admin" }, adminMode = false },
    ["addjailpos"] = { roles = { "admin" }, adminMode = false },
    ["setjailpos"] = { roles = { "admin" }, adminMode = false },
    ["sellall"] = { roles = { "admin" }, adminMode = false },
    ["selldoor"] = { roles = { "admin" }, adminMode = false },
}

print("[Sovereign] Centralized command configuration loaded.")
