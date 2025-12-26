-- sv_chat.lua - Chat commands for Sovereign Admin System

if not SERVER then return end

Sovereign = Sovereign or {}
Sovereign.MutedPlayers = Sovereign.MutedPlayers or {}
Sovereign.GaggedPlayers = Sovereign.GaggedPlayers or {}

-- PM Command - Private Message
Sovereign.RegisterCommand("pm", { "admin", "mod" }, function(admin, args)
    local targetName = args[1]
    local message = table.concat(args, " ", 2)
    
    if not targetName or not message or message == "" then
        Sovereign.NotifyPlayer(admin, "Usage: !pm <player> <message>")
        return
    end
    
    local target = Sovereign.GetPlayerByName(targetName)
    if not IsValid(target) then
        Sovereign.NotifyPlayer(admin, "Player not found: " .. targetName)
        return
    end
    
    -- Send PM
    Sovereign.NotifyPlayer(target, "[PM from " .. admin:Nick() .. "] " .. message)
    Sovereign.NotifyPlayer(admin, "[PM to " .. target:Nick() .. "] " .. message)
end, "Send a private message to a player")

-- Asay Command - Admin Say
Sovereign.RegisterCommand("asay", { "admin", "mod" }, function(admin, args)
    local message = table.concat(args, " ")
    
    if not message or message == "" then
        Sovereign.NotifyPlayer(admin, "Usage: !asay <message>")
        return
    end
    
    -- Send message to all admins
    for _, ply in ipairs(player.GetAll()) do
        if Sovereign.PlayerHasRole(ply, "mod") then
            ply:ChatPrint("[ADMIN] " .. admin:Nick() .. ": " .. message)
        end
    end
end, "Send a message to all admins")

-- Mute Command - Prevent voice chat
Sovereign.RegisterCommand("mute", { "admin", "mod" }, function(admin, args)
    local targetName = args[1]
    local duration = tonumber(args[2]) or 0
    
    if not targetName then
        Sovereign.NotifyPlayer(admin, "Usage: !mute <player> [duration]")
        return
    end
    
    local target = Sovereign.GetPlayerByName(targetName)
    if not IsValid(target) then
        Sovereign.NotifyPlayer(admin, "Player not found: " .. targetName)
        return
    end
    
    -- Mute the player
    target:SetMuted(true)
    Sovereign.MutedPlayers[target:SteamID()] = true
    
    if duration > 0 then
        Sovereign.NotifyPlayer(admin, "Muted " .. target:Nick() .. " for " .. duration .. " seconds")
        Sovereign.NotifyPlayer(target, "You have been voice muted by " .. admin:Nick() .. " for " .. duration .. " seconds")
        
        -- Auto-unmute after duration
        timer.Simple(duration, function()
            if IsValid(target) and Sovereign.MutedPlayers[target:SteamID()] then
                target:SetMuted(false)
                Sovereign.MutedPlayers[target:SteamID()] = nil
                Sovereign.NotifyPlayer(target, "You have been automatically unmuted")
            end
        end)
    else
        Sovereign.NotifyPlayer(admin, "Muted " .. target:Nick() .. " indefinitely")
        Sovereign.NotifyPlayer(target, "You have been voice muted by " .. admin:Nick())
    end
end, "Mute a player's voice chat")

-- Unmute Command - Allow voice chat
Sovereign.RegisterCommand("unmute", { "admin", "mod" }, function(admin, args)
    local targetName = args[1]
    
    if not targetName then
        Sovereign.NotifyPlayer(admin, "Usage: !unmute <player>")
        return
    end
    
    local target = Sovereign.GetPlayerByName(targetName)
    if not IsValid(target) then
        Sovereign.NotifyPlayer(admin, "Player not found: " .. targetName)
        return
    end
    
    if not Sovereign.MutedPlayers[target:SteamID()] then
        Sovereign.NotifyPlayer(admin, target:Nick() .. " is not muted")
        return
    end
    
    -- Unmute the player
    target:SetMuted(false)
    Sovereign.MutedPlayers[target:SteamID()] = nil
    
    Sovereign.NotifyPlayer(admin, "Unmuted " .. target:Nick())
    Sovereign.NotifyPlayer(target, "You have been voice unmuted by " .. admin:Nick())
end, "Unmute a player's voice chat")

-- Gag Command - Prevent text chat
Sovereign.RegisterCommand("gag", { "admin", "mod" }, function(admin, args)
    local targetName = args[1]
    local duration = tonumber(args[2]) or 0
    
    if not targetName then
        Sovereign.NotifyPlayer(admin, "Usage: !gag <player> [duration]")
        return
    end
    
    local target = Sovereign.GetPlayerByName(targetName)
    if not IsValid(target) then
        Sovereign.NotifyPlayer(admin, "Player not found: " .. targetName)
        return
    end
    
    -- Gag the player
    Sovereign.GaggedPlayers[target:SteamID()] = true
    
    if duration > 0 then
        Sovereign.NotifyPlayer(admin, "Gagged " .. target:Nick() .. " for " .. duration .. " seconds")
        Sovereign.NotifyPlayer(target, "You have been chat gagged by " .. admin:Nick() .. " for " .. duration .. " seconds")
        
        -- Auto-ungag after duration
        timer.Simple(duration, function()
            if Sovereign.GaggedPlayers[target:SteamID()] then
                Sovereign.GaggedPlayers[target:SteamID()] = nil
                if IsValid(target) then
                    Sovereign.NotifyPlayer(target, "You have been automatically ungagged")
                end
            end
        end)
    else
        Sovereign.NotifyPlayer(admin, "Gagged " .. target:Nick() .. " indefinitely")
        Sovereign.NotifyPlayer(target, "You have been chat gagged by " .. admin:Nick())
    end
end, "Gag a player's text chat")

-- Ungag Command - Allow text chat
Sovereign.RegisterCommand("ungag", { "admin", "mod" }, function(admin, args)
    local targetName = args[1]
    
    if not targetName then
        Sovereign.NotifyPlayer(admin, "Usage: !ungag <player>")
        return
    end
    
    local target = Sovereign.GetPlayerByName(targetName)
    if not IsValid(target) then
        Sovereign.NotifyPlayer(admin, "Player not found: " .. targetName)
        return
    end
    
    if not Sovereign.GaggedPlayers[target:SteamID()] then
        Sovereign.NotifyPlayer(admin, target:Nick() .. " is not gagged")
        return
    end
    
    -- Ungag the player
    Sovereign.GaggedPlayers[target:SteamID()] = nil
    
    Sovereign.NotifyPlayer(admin, "Ungagged " .. target:Nick())
    Sovereign.NotifyPlayer(target, "You have been chat ungagged by " .. admin:Nick())
end, "Ungag a player's text chat")

-- Hook to prevent gagged players from chatting
hook.Add("PlayerSay", "Sovereign_GagCheck", function(ply, text)
    -- Quick check: skip if no players are gagged
    if not next(Sovereign.GaggedPlayers) then return end
    
    -- Check if player is gagged
    if Sovereign.GaggedPlayers[ply:SteamID()] then
        Sovereign.NotifyPlayer(ply, "You are gagged and cannot use text chat")
        return ""
    end
end)

-- Hook to handle Admin Chat with configurable prefix
hook.Add("PlayerSay", "Sovereign_AdminChat", function(ply, text)
    -- Check if chat config is available
    if not Sovereign.Config.Chat or not Sovereign.Config.Chat.AdminChatPrefix then return end
    
    local prefix = Sovereign.Config.Chat.AdminChatPrefix
    
    -- Check if message starts with admin chat prefix
    if text:sub(1, #prefix) == prefix then
        -- Check if player has mod or higher role
        if not Sovereign.PlayerHasRole(ply, "mod") then
            Sovereign.NotifyPlayer(ply, "You don't have permission to use admin chat.")
            return ""
        end
        
        -- Extract message after prefix
        local message = text:sub(#prefix + 1)
        
        -- Don't send empty messages
        if message == "" or message == " " then
            return ""
        end
        
        -- Send to all staff members
        local chatColor = Sovereign.Config.Chat.Colors.AdminChat
        for _, target in ipairs(player.GetAll()) do
            if Sovereign.PlayerHasRole(target, "mod") then
                target:ChatPrint("[Admin Chat] " .. ply:Nick() .. ": " .. message)
            end
        end
        
        return "" -- Suppress normal chat message
    end
end)

print("[Sovereign] Chat commands loaded.")
