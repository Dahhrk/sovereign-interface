-- admin_system/init.lua
include("config.lua")        -- Configuration settings
include("roles.lua")         -- Role and permission handling
include("commands.lua")      -- Commands (Freeze, Ban, Teleport, etc.)
include("utility.lua")       -- Helper functions
include("database.lua")      -- MySQL/SQLite database integration
include("time_tracking.lua") -- Playtime tracking logic
include("logs.lua")          -- Logging system
include("themes.lua")        -- Optional: UI theming support

print("[Sovereign-Interface] Core system loaded.")