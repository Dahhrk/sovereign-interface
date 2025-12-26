-- sovereign_loader.lua - Entry point for Sovereign Admin System

if SERVER then
    AddCSLuaFile("sovereign/sh_init.lua")
    AddCSLuaFile("sovereign/core/sh_config.lua")
    AddCSLuaFile("sovereign/core/sh_helpers.lua")
    AddCSLuaFile("sovereign/core/sh_roles.lua")
    AddCSLuaFile("sovereign/core/sh_core.lua")
    AddCSLuaFile("sovereign/ui/themes/cl_theme_base.lua")
    
    include("sovereign/sh_init.lua")
    print("[Sovereign] Server-side initialized.")
else
    include("sovereign/sh_init.lua")
    print("[Sovereign] Client-side initialized.")
end