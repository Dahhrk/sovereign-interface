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

-- Ban by ID Command
Sovereign.RegisterCommand("banid", { "superadmin", "admin" }, function(admin, args)
    local steamID = args[1]
    local duration = tonumber(args[2]) or 0
    local reason = table.concat(args, " ", 3) or "No reason given"
    
    if not steamID then
        Sovereign.NotifyPlayer(admin, "Usage: !banid <steamid> <duration> [reason]")
        return
    end
    
    -- Validate SteamID format
    if not Sovereign.Helpers or not Sovereign.Helpers.IsValidSteamID(steamID) then
        -- Basic validation
        if not string.match(steamID, "STEAM_%d:%d:%d+") then
            Sovereign.NotifyPlayer(admin, "Invalid SteamID format")
            return
        end
    end
    
    -- Store ban in database
    if Sovereign.Database and Sovereign.Database.AddBan then
        Sovereign.Database.AddBan(steamID, "Unknown", admin:SteamID(), admin:Nick(), duration, reason)
    end
    
    -- Kick the player if online
    for _, ply in ipairs(player.GetAll()) do
        if ply:SteamID() == steamID then
            local banMessage = "Banned by " .. admin:Nick()
            if duration > 0 then
                banMessage = banMessage .. " for " .. duration .. " minutes"
            else
                banMessage = banMessage .. " permanently"
            end
            banMessage = banMessage .. ". Reason: " .. reason
            ply:Kick(banMessage)
            break
        end
    end
    
    local notifyMessage = admin:Nick() .. " banned SteamID " .. steamID
    if duration > 0 then
        notifyMessage = notifyMessage .. " for " .. duration .. " minutes"
    else
        notifyMessage = notifyMessage .. " permanently"
    end
    notifyMessage = notifyMessage .. ". Reason: " .. reason
    
    Sovereign.NotifyAdmins(notifyMessage)
end, "Ban a player by SteamID")

-- Set Rank Command
Sovereign.RegisterCommand("setrank", { "superadmin" }, function(admin, args)
    local targetName = args[1]
    local rank = args[2]
    
    if not targetName or not rank then
        Sovereign.NotifyPlayer(admin, "Usage: !setrank <player> <rank>")
        return
    end
    
    local target = Sovereign.GetPlayerByName(targetName)
    if not IsValid(target) then
        Sovereign.NotifyPlayer(admin, "Player not found: " .. targetName)
        return
    end
    
    -- Set usergroup
    target:SetUserGroup(rank)
    
    Sovereign.NotifyPlayer(admin, "Set " .. target:Nick() .. "'s rank to " .. rank)
    Sovereign.NotifyPlayer(target, "Your rank was set to " .. rank .. " by " .. admin:Nick())
    Sovereign.NotifyAdmins(admin:Nick() .. " set " .. target:Nick() .. "'s rank to " .. rank)
end, "Set a player's rank/usergroup")

-- Set Rank by ID Command
Sovereign.RegisterCommand("setrankid", { "superadmin" }, function(admin, args)
    local steamID = args[1]
    local rank = args[2]
    
    if not steamID or not rank then
        Sovereign.NotifyPlayer(admin, "Usage: !setrankid <steamid> <rank>")
        return
    end
    
    -- Try to find online player
    local target = nil
    for _, ply in ipairs(player.GetAll()) do
        if ply:SteamID() == steamID then
            target = ply
            break
        end
    end
    
    if IsValid(target) then
        target:SetUserGroup(rank)
        Sovereign.NotifyPlayer(admin, "Set " .. target:Nick() .. "'s rank to " .. rank)
        Sovereign.NotifyPlayer(target, "Your rank was set to " .. rank .. " by " .. admin:Nick())
    else
        Sovereign.NotifyPlayer(admin, "Set rank for SteamID " .. steamID .. " to " .. rank .. " (offline)")
    end
    
    -- Store in database for offline players
    if Sovereign.Database and Sovereign.Database.SetUserRank then
        Sovereign.Database.SetUserRank(steamID, rank)
    end
    
    Sovereign.NotifyAdmins(admin:Nick() .. " set rank for " .. steamID .. " to " .. rank)
end, "Set a player's rank by SteamID")

-- Remove User Command
Sovereign.RegisterCommand("removeuser", { "superadmin" }, function(admin, args)
    local steamID = args[1]
    
    if not steamID then
        Sovereign.NotifyPlayer(admin, "Usage: !removeuser <steamid>")
        return
    end
    
    -- Remove from database
    if Sovereign.Database and Sovereign.Database.RemoveUser then
        Sovereign.Database.RemoveUser(steamID)
    end
    
    -- Reset rank if player is online
    for _, ply in ipairs(player.GetAll()) do
        if ply:SteamID() == steamID then
            ply:SetUserGroup("user")
            Sovereign.NotifyPlayer(ply, "Your rank was reset to user by " .. admin:Nick())
            break
        end
    end
    
    Sovereign.NotifyPlayer(admin, "Removed user data for SteamID: " .. steamID)
    Sovereign.NotifyAdmins(admin:Nick() .. " removed user data for " .. steamID)
end, "Remove a user from the database")

print("[Sovereign] Moderation commands loaded.")