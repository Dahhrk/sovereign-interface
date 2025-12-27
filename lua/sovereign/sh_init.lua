-- sh_init.lua - Initialization script for Sovereign Admin System

print("[Sovereign] Initializing admin system...")

Sovereign = Sovereign or {}

-- Include config modules first
include("sovereign/config/sh_config.lua")         -- Main configuration
include("sovereign/config/sh_roles.lua")          -- Role management
include("sovereign/config/sh_adminmode.lua")      -- Admin mode configuration
include("sovereign/config/sh_commands.lua")       -- Command configuration
include("sovereign/config/sh_limits.lua")         -- Sandbox limits
include("sovereign/config/sh_localization.lua")   -- Localization support
include("sovereign/config/sh_chat.lua")           -- Chat configuration

-- Include core modules
include("sovereign/core/sh_helpers.lua")          -- Helper utilities  
include("sovereign/core/sh_core.lua")             -- Core functionality
include("sovereign/core/sh_compat.lua")           -- Compatibility layer

-- Include server-side modules
if SERVER then
    include("sovereign/storage/sv_database.lua")  -- Database handling
    
    -- Include all command modules
    include("sovereign/commands/sv_admin.lua")      -- Admin mode and role management
    include("sovereign/commands/sv_fun.lua")        -- Fun commands
    include("sovereign/commands/sv_moderation.lua") -- Moderation commands
    include("sovereign/commands/sv_teleport.lua")   -- Teleport commands
    include("sovereign/commands/sv_utility.lua")    -- Utility commands
    include("sovereign/commands/sv_chat.lua")       -- Chat commands
    include("sovereign/commands/sv_darkrp.lua")     -- DarkRP commands
end

-- Include client-side modules
if CLIENT then
    include("sovereign/ui/themes/cl_theme_base.lua") -- UI Theme
end

print("[Sovereign] Admin system loaded successfully!")
print("[Sovereign] Command prefix: " .. (Sovereign.Config.Prefix or "!"))
print("[Sovereign] Total commands registered: " .. table.Count(Sovereign.Commands or {}))