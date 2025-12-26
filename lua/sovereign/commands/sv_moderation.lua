-- sv_moderation.lua - Moderation commands for Sovereign Admin System

if not SERVER then return end

Sovereign = Sovereign or {}

-- Ban Command
Sovereign.RegisterCommand("ban", { "superadmin", "admin" }, function(admin, args)
    local targetName = args[1]
    local duration = tonumber(args[2]) or 0
    local reason = table.concat(args, " ", 3) or "No reason given"
    
    if not targetName then
        Sovereign.NotifyPlayer(admin, "Usage: !ban <player> <duration> [reason]")
        return
    end
    
    local target = Sovereign.GetPlayerByName(targetName)
    if not IsValid(target) then
        Sovereign.NotifyPlayer(admin, "Player not found: " .. targetName)
        return
    end
    
    -- Store ban in database
    if Sovereign.Database and Sovereign.Database.AddBan then
        Sovereign.Database.AddBan(target:SteamID(), target:Nick(), admin:SteamID(), admin:Nick(), duration, reason)
    end
    
    -- Kick the player
    local banMessage = "Banned by " .. admin:Nick()
    if duration > 0 then
        banMessage = banMessage .. " for " .. duration .. " minutes"
    else
        banMessage = banMessage .. " permanently"
    end
    banMessage = banMessage .. ". Reason: " .. reason
    
    target:Kick(banMessage)
    
    -- Notify admins
    local notifyMessage = admin:Nick() .. " banned " .. target:Nick()
    if duration > 0 then
        notifyMessage = notifyMessage .. " for " .. duration .. " minutes"
    else
        notifyMessage = notifyMessage .. " permanently"
    end
    notifyMessage = notifyMessage .. ". Reason: " .. reason
    
    Sovereign.NotifyAdmins(notifyMessage)
end, "Ban a player from the server")

-- Unban Command
Sovereign.RegisterCommand("unban", { "superadmin", "admin" }, function(admin, args)
    local steamID = args[1]
    
    if not steamID then
        Sovereign.NotifyPlayer(admin, "Usage: !unban <steamid>")
        return
    end
    
    -- Remove ban from database
    if Sovereign.Database and Sovereign.Database.RemoveBan then
        Sovereign.Database.RemoveBan(steamID)
        Sovereign.NotifyPlayer(admin, "Unbanned SteamID: " .. steamID)
        Sovereign.NotifyAdmins(admin:Nick() .. " unbanned SteamID: " .. steamID)
    else
        Sovereign.NotifyPlayer(admin, "Database not available")
    end
end, "Unban a player by SteamID")

-- Kick Command
Sovereign.RegisterCommand("kick", { "admin", "mod" }, function(admin, args)
    local targetName = args[1]
    local reason = table.concat(args, " ", 2) or "No reason given"
    
    if not targetName then
        Sovereign.NotifyPlayer(admin, "Usage: !kick <player> [reason]")
        return
    end
    
    local target = Sovereign.GetPlayerByName(targetName)
    if not IsValid(target) then
        Sovereign.NotifyPlayer(admin, "Player not found: " .. targetName)
        return
    end
    
    target:Kick("Kicked by " .. admin:Nick() .. ". Reason: " .. reason)
    Sovereign.NotifyAdmins(admin:Nick() .. " kicked " .. target:Nick() .. ". Reason: " .. reason)
end, "Kick a player from the server")

-- Warn Command
Sovereign.RegisterCommand("warn", { "admin", "mod" }, function(admin, args)
    local targetName = args[1]
    local reason = table.concat(args, " ", 2) or "No reason given"
    
    if not targetName then
        Sovereign.NotifyPlayer(admin, "Usage: !warn <player> [reason]")
        return
    end
    
    local target = Sovereign.GetPlayerByName(targetName)
    if not IsValid(target) then
        Sovereign.NotifyPlayer(admin, "Player not found: " .. targetName)
        return
    end
    
    -- Store warning in database
    if Sovereign.Database and Sovereign.Database.AddWarning then
        Sovereign.Database.AddWarning(target:SteamID(), target:Nick(), admin:SteamID(), admin:Nick(), reason)
    end
    
    Sovereign.NotifyPlayer(admin, "You warned " .. target:Nick() .. " for: " .. reason)
    Sovereign.NotifyPlayer(target, "You have been warned by " .. admin:Nick() .. " for: " .. reason)
    Sovereign.NotifyAdmins(admin:Nick() .. " warned " .. target:Nick() .. " for: " .. reason)
end, "Warn a player")

-- Slay Command
Sovereign.RegisterCommand("slay", { "admin" }, function(admin, args)
    local targetName = args[1]
    
    if not targetName then
        Sovereign.NotifyPlayer(admin, "Usage: !slay <player>")
        return
    end
    
    local target = Sovereign.GetPlayerByName(targetName)
    if not IsValid(target) then
        Sovereign.NotifyPlayer(admin, "Player not found: " .. targetName)
        return
    end
    
    target:Kill()
    Sovereign.NotifyPlayer(admin, "You slayed " .. target:Nick())
    Sovereign.NotifyPlayer(target, "You were slayed by " .. admin:Nick())
end, "Kill a player instantly")

print("[Sovereign] Moderation commands loaded.")