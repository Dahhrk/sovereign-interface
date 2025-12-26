-- sh_config.lua - Main configuration for Sovereign Admin System

Sovereign = Sovereign or {}
Sovereign.Config = Sovereign.Config or {}

-- Command prefix
Sovereign.Config.Prefix = "!"

-- Default authorized user groups (only superadmin by default as per requirements)
Sovereign.Config.AuthorizedGroups = { "superadmin" }

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

-- Jail configuration
Sovereign.Config.JailModel = "models/props_phx/construct/metal_plate1.mdl"

-- Advert settings
Sovereign.Config.Adverts = {
    Enabled = true,
    Interval = 300, -- seconds between adverts
    Messages = {
        "This server uses Sovereign Admin System!",
        "Report rule breakers to admins using @ in chat.",
        "Type !help for a list of available commands."
    }
}

print("[Sovereign] Configuration loaded.")
