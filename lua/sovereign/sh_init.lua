print("[Sovereign] Initializing core admin system...")

-- Core Modules
include("roles/sh_roles.lua")         -- Role management
include("storage/sv_database.lua")   -- Database handling
include("commands/sh_config.lua")    -- Command configuration
include("commands/sv_fun.lua")       -- Fun commands
include("commands/sv_moderation.lua") -- Moderation commands
include("commands/sv_teleport.lua")  -- Teleport commands
include("commands/sv_utility.lua")   -- Utility commands

print("[Sovereign] Core admin system loaded.")