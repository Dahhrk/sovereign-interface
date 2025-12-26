-- sv_teleport.lua - Teleportation commands for Sovereign Admin System

if not SERVER then return end

Sovereign = Sovereign or {}
Sovereign.TeleportHistory = Sovereign.TeleportHistory or {}

-- Goto Command - Teleport to a player
Sovereign.RegisterCommand("goto", { "admin", "mod" }, function(admin, args)
    local targetName = args[1]
    
    if not targetName then
        Sovereign.NotifyPlayer(admin, "Usage: !goto <player>")
        return
    end
    
    local target = Sovereign.GetPlayerByName(targetName)
    if not IsValid(target) then
        Sovereign.NotifyPlayer(admin, "Player not found: " .. targetName)
        return
    end
    
    if target == admin then
        Sovereign.NotifyPlayer(admin, "You cannot teleport to yourself")
        return
    end
    
    -- Save current position for return command
    Sovereign.TeleportHistory[admin:SteamID()] = {
        pos = admin:GetPos(),
        ang = admin:EyeAngles(),
        time = CurTime()
    }
    
    -- Teleport to target
    admin:SetPos(target:GetPos() + Vector(0, 0, 10))
    admin:SetEyeAngles(target:EyeAngles())
    
    Sovereign.NotifyPlayer(admin, "Teleported to " .. target:Nick())
end, "Teleport to a player")

-- Bring Command - Teleport a player to you
Sovereign.RegisterCommand("bring", { "admin", "mod" }, function(admin, args)
    local targetName = args[1]
    
    if not targetName then
        Sovereign.NotifyPlayer(admin, "Usage: !bring <player>")
        return
    end
    
    local target = Sovereign.GetPlayerByName(targetName)
    if not IsValid(target) then
        Sovereign.NotifyPlayer(admin, "Player not found: " .. targetName)
        return
    end
    
    if target == admin then
        Sovereign.NotifyPlayer(admin, "You cannot bring yourself")
        return
    end
    
    -- Save target's position for their return command
    Sovereign.TeleportHistory[target:SteamID()] = {
        pos = target:GetPos(),
        ang = target:EyeAngles(),
        time = CurTime()
    }
    
    -- Get position in front of admin
    local adminPos = admin:GetPos()
    local adminAng = admin:EyeAngles()
    local forward = adminAng:Forward()
    local bringPos = adminPos + forward * 100
    
    -- Teleport target to admin
    target:SetPos(bringPos)
    target:SetEyeAngles(Angle(0, adminAng.y + 180, 0))
    
    Sovereign.NotifyPlayer(admin, "Brought " .. target:Nick() .. " to you")
    Sovereign.NotifyPlayer(target, "You have been brought to " .. admin:Nick())
end, "Bring a player to you")

-- Return Command - Return to previous position
Sovereign.RegisterCommand("return", { "admin", "mod" }, function(admin, args)
    local targetName = args[1]
    
    -- If no target specified, return the admin
    if not targetName then
        local history = Sovereign.TeleportHistory[admin:SteamID()]
        
        if not history then
            Sovereign.NotifyPlayer(admin, "No previous location to return to")
            return
        end
        
        admin:SetPos(history.pos)
        admin:SetEyeAngles(history.ang)
        Sovereign.TeleportHistory[admin:SteamID()] = nil
        
        Sovereign.NotifyPlayer(admin, "Returned to previous location")
        return
    end
    
    -- Return a target player
    local target = Sovereign.GetPlayerByName(targetName)
    if not IsValid(target) then
        Sovereign.NotifyPlayer(admin, "Player not found: " .. targetName)
        return
    end
    
    local history = Sovereign.TeleportHistory[target:SteamID()]
    if not history then
        Sovereign.NotifyPlayer(admin, target:Nick() .. " has no previous location to return to")
        return
    end
    
    target:SetPos(history.pos)
    target:SetEyeAngles(history.ang)
    Sovereign.TeleportHistory[target:SteamID()] = nil
    
    Sovereign.NotifyPlayer(admin, "Returned " .. target:Nick() .. " to previous location")
    Sovereign.NotifyPlayer(target, "You have been returned to your previous location")
end, "Return to previous location or return a player")

-- Teleport Command - Teleport to coordinates
Sovereign.RegisterCommand("tp", { "admin" }, function(admin, args)
    local x = tonumber(args[1])
    local y = tonumber(args[2])
    local z = tonumber(args[3])
    
    if not x or not y or not z then
        Sovereign.NotifyPlayer(admin, "Usage: !tp <x> <y> <z>")
        return
    end
    
    -- Save current position for return command
    Sovereign.TeleportHistory[admin:SteamID()] = {
        pos = admin:GetPos(),
        ang = admin:EyeAngles(),
        time = CurTime()
    }
    
    admin:SetPos(Vector(x, y, z))
    Sovereign.NotifyPlayer(admin, "Teleported to coordinates: " .. x .. ", " .. y .. ", " .. z)
end, "Teleport to specific coordinates")

-- Send Command - Send one player to another
Sovereign.RegisterCommand("send", { "admin" }, function(admin, args)
    local targetName = args[1]
    local destName = args[2]
    
    if not targetName or not destName then
        Sovereign.NotifyPlayer(admin, "Usage: !send <player> <destination_player>")
        return
    end
    
    local target = Sovereign.GetPlayerByName(targetName)
    local destination = Sovereign.GetPlayerByName(destName)
    
    if not IsValid(target) then
        Sovereign.NotifyPlayer(admin, "Player not found: " .. targetName)
        return
    end
    
    if not IsValid(destination) then
        Sovereign.NotifyPlayer(admin, "Destination player not found: " .. destName)
        return
    end
    
    -- Save target's position for return command
    Sovereign.TeleportHistory[target:SteamID()] = {
        pos = target:GetPos(),
        ang = target:EyeAngles(),
        time = CurTime()
    }
    
    target:SetPos(destination:GetPos() + Vector(0, 0, 10))
    
    Sovereign.NotifyPlayer(admin, "Sent " .. target:Nick() .. " to " .. destination:Nick())
    Sovereign.NotifyPlayer(target, "You have been sent to " .. destination:Nick() .. " by " .. admin:Nick())
end, "Send one player to another player")

print("[Sovereign] Teleport commands loaded.")
