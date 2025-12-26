-- sv_utility.lua - Utility commands for Sovereign Admin System

if not SERVER then return end

Sovereign = Sovereign or {}

-- Noclip Command
Sovereign.RegisterCommand("noclip", { "admin", "mod" }, function(admin, args)
    local targetName = args[1]
    
    -- If no target specified, toggle for the admin
    if not targetName then
        local moveType = admin:GetMoveType()
        
        if moveType == MOVETYPE_NOCLIP then
            admin:SetMoveType(MOVETYPE_WALK)
            Sovereign.NotifyPlayer(admin, "Noclip disabled")
        else
            admin:SetMoveType(MOVETYPE_NOCLIP)
            Sovereign.NotifyPlayer(admin, "Noclip enabled")
        end
        return
    end
    
    -- Toggle noclip for target
    local target = Sovereign.GetPlayerByName(targetName)
    if not IsValid(target) then
        Sovereign.NotifyPlayer(admin, "Player not found: " .. targetName)
        return
    end
    
    local moveType = target:GetMoveType()
    
    if moveType == MOVETYPE_NOCLIP then
        target:SetMoveType(MOVETYPE_WALK)
        Sovereign.NotifyPlayer(admin, "Disabled noclip for " .. target:Nick())
        Sovereign.NotifyPlayer(target, "Noclip disabled by " .. admin:Nick())
    else
        target:SetMoveType(MOVETYPE_NOCLIP)
        Sovereign.NotifyPlayer(admin, "Enabled noclip for " .. target:Nick())
        Sovereign.NotifyPlayer(target, "Noclip enabled by " .. admin:Nick())
    end
end, "Toggle noclip mode")

-- Cloak Command
Sovereign.RegisterCommand("cloak", { "admin", "mod" }, function(admin, args)
    local targetName = args[1]
    
    -- If no target specified, cloak the admin
    if not targetName then
        admin:SetNoDraw(true)
        admin:SetNotSolid(true)
        admin:DrawWorldModel(false)
        Sovereign.NotifyPlayer(admin, "You are now cloaked")
        return
    end
    
    -- Cloak target
    local target = Sovereign.GetPlayerByName(targetName)
    if not IsValid(target) then
        Sovereign.NotifyPlayer(admin, "Player not found: " .. targetName)
        return
    end
    
    target:SetNoDraw(true)
    target:SetNotSolid(true)
    target:DrawWorldModel(false)
    
    Sovereign.NotifyPlayer(admin, "Cloaked " .. target:Nick())
    Sovereign.NotifyPlayer(target, "You have been cloaked by " .. admin:Nick())
end, "Make a player invisible")

-- Uncloak Command
Sovereign.RegisterCommand("uncloak", { "admin", "mod" }, function(admin, args)
    local targetName = args[1]
    
    -- If no target specified, uncloak the admin
    if not targetName then
        admin:SetNoDraw(false)
        admin:SetNotSolid(false)
        admin:DrawWorldModel(true)
        Sovereign.NotifyPlayer(admin, "You are no longer cloaked")
        return
    end
    
    -- Uncloak target
    local target = Sovereign.GetPlayerByName(targetName)
    if not IsValid(target) then
        Sovereign.NotifyPlayer(admin, "Player not found: " .. targetName)
        return
    end
    
    target:SetNoDraw(false)
    target:SetNotSolid(false)
    target:DrawWorldModel(true)
    
    Sovereign.NotifyPlayer(admin, "Uncloaked " .. target:Nick())
    Sovereign.NotifyPlayer(target, "You have been uncloaked by " .. admin:Nick())
end, "Make a cloaked player visible again")

-- God Command
Sovereign.RegisterCommand("god", { "admin" }, function(admin, args)
    local targetName = args[1]
    
    -- If no target specified, enable god mode for admin
    if not targetName then
        admin:GodEnable()
        Sovereign.NotifyPlayer(admin, "God mode enabled")
        return
    end
    
    -- Enable god mode for target
    local target = Sovereign.GetPlayerByName(targetName)
    if not IsValid(target) then
        Sovereign.NotifyPlayer(admin, "Player not found: " .. targetName)
        return
    end
    
    target:GodEnable()
    Sovereign.NotifyPlayer(admin, "Enabled god mode for " .. target:Nick())
    Sovereign.NotifyPlayer(target, "God mode enabled by " .. admin:Nick())
end, "Enable god mode (invincibility)")

-- Ungod Command
Sovereign.RegisterCommand("ungod", { "admin" }, function(admin, args)
    local targetName = args[1]
    
    -- If no target specified, disable god mode for admin
    if not targetName then
        admin:GodDisable()
        Sovereign.NotifyPlayer(admin, "God mode disabled")
        return
    end
    
    -- Disable god mode for target
    local target = Sovereign.GetPlayerByName(targetName)
    if not IsValid(target) then
        Sovereign.NotifyPlayer(admin, "Player not found: " .. targetName)
        return
    end
    
    target:GodDisable()
    Sovereign.NotifyPlayer(admin, "Disabled god mode for " .. target:Nick())
    Sovereign.NotifyPlayer(target, "God mode disabled by " .. admin:Nick())
end, "Disable god mode")

-- Health Command
Sovereign.RegisterCommand("hp", { "admin", "mod" }, function(admin, args)
    local targetName = args[1]
    local health = tonumber(args[2]) or 100
    
    if not targetName then
        Sovereign.NotifyPlayer(admin, "Usage: !hp <player> [amount]")
        return
    end
    
    local target = Sovereign.GetPlayerByName(targetName)
    if not IsValid(target) then
        Sovereign.NotifyPlayer(admin, "Player not found: " .. targetName)
        return
    end
    
    target:SetHealth(health)
    target:SetMaxHealth(health)
    
    Sovereign.NotifyPlayer(admin, "Set " .. target:Nick() .. "'s health to " .. health)
    Sovereign.NotifyPlayer(target, "Your health was set to " .. health .. " by " .. admin:Nick())
end, "Set a player's health")

-- Armor Command
Sovereign.RegisterCommand("armor", { "admin", "mod" }, function(admin, args)
    local targetName = args[1]
    local armor = tonumber(args[2]) or 100
    
    if not targetName then
        Sovereign.NotifyPlayer(admin, "Usage: !armor <player> [amount]")
        return
    end
    
    local target = Sovereign.GetPlayerByName(targetName)
    if not IsValid(target) then
        Sovereign.NotifyPlayer(admin, "Player not found: " .. targetName)
        return
    end
    
    target:SetArmor(armor)
    
    Sovereign.NotifyPlayer(admin, "Set " .. target:Nick() .. "'s armor to " .. armor)
    Sovereign.NotifyPlayer(target, "Your armor was set to " .. armor .. " by " .. admin:Nick())
end, "Set a player's armor")

-- Strip Weapons Command
Sovereign.RegisterCommand("strip", { "admin" }, function(admin, args)
    local targetName = args[1]
    
    if not targetName then
        Sovereign.NotifyPlayer(admin, "Usage: !strip <player>")
        return
    end
    
    local target = Sovereign.GetPlayerByName(targetName)
    if not IsValid(target) then
        Sovereign.NotifyPlayer(admin, "Player not found: " .. targetName)
        return
    end
    
    target:StripWeapons()
    
    Sovereign.NotifyPlayer(admin, "Stripped all weapons from " .. target:Nick())
    Sovereign.NotifyPlayer(target, "Your weapons were stripped by " .. admin:Nick())
end, "Remove all weapons from a player")

-- Respawn Command
Sovereign.RegisterCommand("respawn", { "admin", "mod" }, function(admin, args)
    local targetName = args[1]
    
    if not targetName then
        Sovereign.NotifyPlayer(admin, "Usage: !respawn <player>")
        return
    end
    
    local target = Sovereign.GetPlayerByName(targetName)
    if not IsValid(target) then
        Sovereign.NotifyPlayer(admin, "Player not found: " .. targetName)
        return
    end
    
    target:Spawn()
    
    Sovereign.NotifyPlayer(admin, "Respawned " .. target:Nick())
    Sovereign.NotifyPlayer(target, "You were respawned by " .. admin:Nick())
end, "Respawn a player")

-- Stop Sound Command
Sovereign.RegisterCommand("stopsound", { "admin", "mod" }, function(admin, args)
    local targetName = args[1]
    
    -- If no target specified, stop sounds for admin
    if not targetName then
        admin:SendLua("RunConsoleCommand('stopsound')")
        Sovereign.NotifyPlayer(admin, "Stopped all sounds for you")
        return
    end
    
    -- Stop sounds for target
    local target = Sovereign.GetPlayerByName(targetName)
    if not IsValid(target) then
        Sovereign.NotifyPlayer(admin, "Player not found: " .. targetName)
        return
    end
    
    target:SendLua("RunConsoleCommand('stopsound')")
    Sovereign.NotifyPlayer(admin, "Stopped all sounds for " .. target:Nick())
    Sovereign.NotifyPlayer(target, "All sounds stopped by " .. admin:Nick())
end, "Stop all sounds for a player")

-- Clear Decals Command
Sovereign.RegisterCommand("cleardecals", { "admin", "mod" }, function(admin, args)
    local targetName = args[1]
    
    -- If no target specified, clear decals for admin
    if not targetName then
        admin:SendLua("RunConsoleCommand('r_cleardecals')")
        Sovereign.NotifyPlayer(admin, "Cleared decals for you")
        return
    end
    
    -- Clear decals for target
    local target = Sovereign.GetPlayerByName(targetName)
    if not IsValid(target) then
        Sovereign.NotifyPlayer(admin, "Player not found: " .. targetName)
        return
    end
    
    target:SendLua("RunConsoleCommand('r_cleardecals')")
    Sovereign.NotifyPlayer(admin, "Cleared decals for " .. target:Nick())
    Sovereign.NotifyPlayer(target, "Decals cleared by " .. admin:Nick())
end, "Clear decals for a player")

-- Map Command
Sovereign.RegisterCommand("map", { "superadmin", "admin" }, function(admin, args)
    local mapName = args[1]
    
    if not mapName then
        Sovereign.NotifyPlayer(admin, "Usage: !map <mapname>")
        return
    end
    
    Sovereign.NotifyAdmins(admin:Nick() .. " is changing map to " .. mapName)
    
    timer.Simple(3, function()
        RunConsoleCommand("changelevel", mapName)
    end)
end, "Change the server map")

-- Map Restart Command
Sovereign.RegisterCommand("maprestart", { "superadmin", "admin" }, function(admin, args)
    local delay = tonumber(args[1]) or 3
    
    Sovereign.NotifyAdmins(admin:Nick() .. " is restarting the map in " .. delay .. " seconds")
    
    timer.Simple(delay, function()
        game.CleanUpMap()
        for _, ply in ipairs(player.GetAll()) do
            ply:Spawn()
        end
    end)
end, "Restart the current map")

-- Map Reset Command
Sovereign.RegisterCommand("mapreset", { "superadmin", "admin" }, function(admin, args)
    game.CleanUpMap()
    Sovereign.NotifyAdmins(admin:Nick() .. " reset all map entities")
end, "Reset all map entities")

-- Give Weapon/Entity Command
Sovereign.RegisterCommand("give", { "admin" }, function(admin, args)
    local targetName = args[1]
    local entityClass = args[2]
    
    if not targetName or not entityClass then
        Sovereign.NotifyPlayer(admin, "Usage: !give <player> <weapon/entity>")
        return
    end
    
    local target = Sovereign.GetPlayerByName(targetName)
    if not IsValid(target) then
        Sovereign.NotifyPlayer(admin, "Player not found: " .. targetName)
        return
    end
    
    target:Give(entityClass)
    Sovereign.NotifyPlayer(admin, "Gave " .. entityClass .. " to " .. target:Nick())
    Sovereign.NotifyPlayer(target, "You received " .. entityClass .. " from " .. admin:Nick())
end, "Give a weapon or entity to a player")

-- Playtime tracking table
Sovereign.PlaytimeData = Sovereign.PlaytimeData or {}

-- Track player join time
hook.Add("PlayerInitialSpawn", "Sovereign_TrackPlaytime", function(ply)
    Sovereign.PlaytimeData[ply:SteamID()] = {
        joinTime = os.time(),
        sessionStart = CurTime()
    }
end)

-- Update playtime on disconnect
hook.Add("PlayerDisconnected", "Sovereign_SavePlaytime", function(ply)
    local data = Sovereign.PlaytimeData[ply:SteamID()]
    if data and Sovereign.Database and Sovereign.Database.UpdatePlaytime then
        local sessionTime = CurTime() - data.sessionStart
        Sovereign.Database.UpdatePlaytime(ply:SteamID(), sessionTime)
    end
    Sovereign.PlaytimeData[ply:SteamID()] = nil
end)

-- Time Command
Sovereign.RegisterCommand("time", { "admin", "mod" }, function(admin, args)
    local targetName = args[1]
    
    if not targetName then
        Sovereign.NotifyPlayer(admin, "Usage: !time <player>")
        return
    end
    
    local target = Sovereign.GetPlayerByName(targetName)
    if not IsValid(target) then
        Sovereign.NotifyPlayer(admin, "Player not found: " .. targetName)
        return
    end
    
    local data = Sovereign.PlaytimeData[target:SteamID()]
    if data then
        local sessionTime = CurTime() - data.sessionStart
        local formattedTime = string.FormattedTime(sessionTime, "%02i:%02i:%02i")
        Sovereign.NotifyPlayer(admin, target:Nick() .. " current session: " .. formattedTime)
    else
        Sovereign.NotifyPlayer(admin, "No playtime data for " .. target:Nick())
    end
end, "Show player's current session playtime")

-- Total Time Command
Sovereign.RegisterCommand("totaltime", { "admin", "mod" }, function(admin, args)
    local targetName = args[1]
    
    if not targetName then
        Sovereign.NotifyPlayer(admin, "Usage: !totaltime <player>")
        return
    end
    
    local target = Sovereign.GetPlayerByName(targetName)
    if not IsValid(target) then
        Sovereign.NotifyPlayer(admin, "Player not found: " .. targetName)
        return
    end
    
    if Sovereign.Database and Sovereign.Database.GetPlaytime then
        Sovereign.Database.GetPlaytime(target:SteamID(), function(totalSeconds)
            if totalSeconds then
                local formattedTime = string.FormattedTime(totalSeconds, "%02i:%02i:%02i")
                Sovereign.NotifyPlayer(admin, target:Nick() .. " total playtime: " .. formattedTime)
            else
                Sovereign.NotifyPlayer(admin, "No total playtime data for " .. target:Nick())
            end
        end)
    else
        Sovereign.NotifyPlayer(admin, "Database not available for playtime tracking")
    end
end, "Show player's total playtime on server")

print("[Sovereign] Utility commands loaded.")
