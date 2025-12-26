-- sh_adminmode.lua - Admin Mode configuration for Sovereign Admin System

Sovereign = Sovereign or {}
Sovereign.Config = Sovereign.Config or {}
Sovereign.Config.AdminMode = Sovereign.Config.AdminMode or {}

-- Admin Mode Settings
Sovereign.Config.AdminMode.Enabled = true

-- Command Restrictions
Sovereign.Config.AdminMode.RestrictCommands = true  -- Enable/disable command restrictions globally

-- Admin Model (player model when in admin mode)
Sovereign.Config.AdminMode.Model = "models/player/combine_super_soldier.mdl"

-- Admin Mode Stats
Sovereign.Config.AdminMode.GodMode = true
Sovereign.Config.AdminMode.Health = 100
Sovereign.Config.AdminMode.Armor = 100
Sovereign.Config.AdminMode.Speed = 1.5  -- Walk speed multiplier
Sovereign.Config.AdminMode.JumpPower = 1.5  -- Jump power multiplier

-- Sounds
Sovereign.Config.AdminMode.Sounds = {
    Enable = "buttons/button9.wav",      -- Sound when entering admin mode (EntrySound)
    Disable = "buttons/button10.wav"     -- Sound when leaving admin mode (ExitSound)
}

-- Admin Mode Visibility
Sovereign.Config.AdminMode.Cloak = false  -- Make admin invisible in admin mode
Sovereign.Config.AdminMode.ShowHUD = true  -- Show special HUD indicator

-- DarkRP Integration
Sovereign.Config.AdminMode.DarkRP = {
    Enabled = true,
    AdminJobName = "Admin on Duty",  -- Job name for admin mode in DarkRP
    RememberJob = true,               -- Remember player's previous job
    RememberWeapons = true            -- Remember player's weapons
}

-- Admin Mode Key Bind (can be nil to disable)
-- Players can use this key to toggle admin mode if they have permission
Sovereign.Config.AdminMode.ToggleKey = KEY_F2

print("[Sovereign] Admin Mode configuration loaded.")
