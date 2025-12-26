-- sovereign_loader.lua - Entry point for Sovereign Admin System

if SERVER then
    AddCSLuaFile("sovereign/sh_init.lua")
    
    -- Add config files to client
    AddCSLuaFile("sovereign/config/sh_config.lua")
    AddCSLuaFile("sovereign/config/sh_roles.lua")
    AddCSLuaFile("sovereign/config/sh_adminmode.lua")
    AddCSLuaFile("sovereign/config/sh_limits.lua")
    AddCSLuaFile("sovereign/config/sh_localization.lua")
    
    -- Add core files to client
    AddCSLuaFile("sovereign/core/sh_helpers.lua")
    AddCSLuaFile("sovereign/core/sh_core.lua")
    AddCSLuaFile("sovereign/core/sh_compat.lua")
    
    -- Add UI files to client
    AddCSLuaFile("sovereign/ui/themes/cl_theme_base.lua")
    
    include("sovereign/sh_init.lua")
    print("[Sovereign] Server-side initialized.")
else
    include("sovereign/sh_init.lua")
    print("[Sovereign] Client-side initialized.")
end