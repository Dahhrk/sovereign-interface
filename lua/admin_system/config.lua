-- admin_system/config.lua
Config = {}

-- Command prefix
Config.Prefix = "!"

-- Adverts to broadcast periodically
Config.Adverts = {
    "Welcome to the server!",
    "Check the rules in /rules!",
    "Need help? Ask an admin!"
}

-- Define roles (for rank-based permissions)
Config.Roles = { "superadmin", "admin", "mod", "user" }