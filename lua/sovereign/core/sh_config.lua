-- sh_config.lua - Configuration for Sovereign Admin System

Sovereign = Sovereign or {}
Sovereign.Config = Sovereign.Config or {}

-- Command prefix
Sovereign.Config.Prefix = "!"

-- Default authorized user groups
Sovereign.Config.AuthorizedGroups = { "admin", "superadmin", "mod" }

-- Command cooldown (in seconds)
Sovereign.Config.CommandCooldown = 0.5

-- Enable command logging
Sovereign.Config.EnableLogging = true

-- Database configuration
Sovereign.Config.Database = {
    Type = "sqlite", -- "mysql" or "sqlite"
    MySQL = {
        Host = "localhost",
        Port = 3306,
        Username = "root",
        Password = "",
        Database = "sovereign"
    },
    SQLite = {
        Path = "sovereign.db"
    }
}

-- Default ban durations (in minutes)
Sovereign.Config.BanDurations = {
    short = 60,      -- 1 hour
    medium = 1440,   -- 24 hours
    long = 10080,    -- 1 week
    permanent = 0    -- 0 = permanent
}

print("[Sovereign] Configuration loaded.")