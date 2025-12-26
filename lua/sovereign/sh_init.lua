-- sh_init.lua - Initialization script for Sovereign Admin System

print("[Sovereign] Initializing admin system...")

Sovereign = Sovereign or {}

-- Include core modules first
include("sovereign/core/sh_config.lua")      -- Configuration
include("sovereign/core/sh_helpers.lua")     -- Helper utilities  
include("sovereign/core/sh_roles.lua")       -- Role management
include("sovereign/core/sh_core.lua")        -- Core functionality

-- Include server-side modules
if SERVER then
    include("sovereign/storage/sv_database.lua")   -- Database handling
    
    -- Include all command modules
    include("sovereign/commands/sv_fun.lua")        -- Fun commands
    include("sovereign/commands/sv_moderation.lua") -- Moderation commands
    include("sovereign/commands/sv_teleport.lua")   -- Teleport commands
    include("sovereign/commands/sv_utility.lua")    -- Utility commands
end

-- Include client-side modules
if CLIENT then
    include("sovereign/ui/themes/cl_theme_base.lua") -- UI Theme
end

print("[Sovereign] Admin system loaded successfully!")
print("[Sovereign] Command prefix: " .. (Sovereign.Config.Prefix or "!"))
print("[Sovereign] Total commands registered: " .. table.Count(Sovereign.Commands or {}))