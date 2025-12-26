-- sv_fun.lua - Fun commands for Sovereign Admin System

if not SERVER then return end

Sovereign = Sovereign or {}

-- Freeze Command
Sovereign.RegisterCommand("freeze", { "admin", "mod" }, function(admin, args)
    local targetName = args[1]
    if not targetName then
        Sovereign.NotifyPlayer(admin, "Usage: !freeze <player>")
        return
    end
    
    local target = Sovereign.GetPlayerByName(targetName)
    if not IsValid(target) then
        Sovereign.NotifyPlayer(admin, "Player not found: " .. targetName)
        return
    end
    
    target:Freeze(true)
    Sovereign.NotifyPlayer(admin, "You froze " .. target:Nick())
    Sovereign.NotifyPlayer(target, "You have been frozen by " .. admin:Nick())
end, "Freeze a player in place")

-- Unfreeze Command
Sovereign.RegisterCommand("unfreeze", { "admin", "mod" }, function(admin, args)
    local targetName = args[1]
    if not targetName then
        Sovereign.NotifyPlayer(admin, "Usage: !unfreeze <player>")
        return
    end
    
    local target = Sovereign.GetPlayerByName(targetName)
    if not IsValid(target) then
        Sovereign.NotifyPlayer(admin, "Player not found: " .. targetName)
        return
    end
    
    target:Freeze(false)
    Sovereign.NotifyPlayer(admin, "You unfroze " .. target:Nick())
    Sovereign.NotifyPlayer(target, "You have been unfrozen by " .. admin:Nick())
end, "Unfreeze a frozen player")

-- Slap Command
Sovereign.RegisterCommand("slap", { "admin", "mod" }, function(admin, args)
    local targetName = args[1]
    local damage = tonumber(args[2]) or 0
    
    if not targetName then
        Sovereign.NotifyPlayer(admin, "Usage: !slap <player> [damage]")
        return
    end
    
    local target = Sovereign.GetPlayerByName(targetName)
    if not IsValid(target) then
        Sovereign.NotifyPlayer(admin, "Player not found: " .. targetName)
        return
    end
    
    -- Apply damage if specified
    if damage > 0 then
        target:TakeDamage(damage, admin, admin)
    end
    
    -- Apply upward velocity for slap effect (preserve horizontal velocity)
    local currentVel = target:GetVelocity()
    target:SetVelocity(Vector(
        currentVel.x + math.random(-100, 100),
        currentVel.y + math.random(-100, 100),
        200
    ))
    
    Sovereign.NotifyPlayer(admin, "You slapped " .. target:Nick() .. " for " .. damage .. " damage")
    Sovereign.NotifyPlayer(target, "You were slapped by " .. admin:Nick())
end, "Slap a player with optional damage")

-- Ignite Command
Sovereign.RegisterCommand("ignite", { "admin" }, function(admin, args)
    local targetName = args[1]
    local duration = tonumber(args[2]) or 10
    
    if not targetName then
        Sovereign.NotifyPlayer(admin, "Usage: !ignite <player> [duration]")
        return
    end
    
    local target = Sovereign.GetPlayerByName(targetName)
    if not IsValid(target) then
        Sovereign.NotifyPlayer(admin, "Player not found: " .. targetName)
        return
    end
    
    target:Ignite(duration)
    Sovereign.NotifyPlayer(admin, "You ignited " .. target:Nick() .. " for " .. duration .. " seconds")
    Sovereign.NotifyPlayer(target, "You have been ignited by " .. admin:Nick())
end, "Set a player on fire")

-- Extinguish Command
Sovereign.RegisterCommand("extinguish", { "admin", "mod" }, function(admin, args)
    local targetName = args[1]
    
    if not targetName then
        Sovereign.NotifyPlayer(admin, "Usage: !extinguish <player>")
        return
    end
    
    local target = Sovereign.GetPlayerByName(targetName)
    if not IsValid(target) then
        Sovereign.NotifyPlayer(admin, "Player not found: " .. targetName)
        return
    end
    
    target:Extinguish()
    Sovereign.NotifyPlayer(admin, "You extinguished " .. target:Nick())
    Sovereign.NotifyPlayer(target, "You have been extinguished by " .. admin:Nick())
end, "Extinguish a burning player")

-- Jail Command
Sovereign = Sovereign or {}
Sovereign.JailedPlayers = Sovereign.JailedPlayers or {}

Sovereign.RegisterCommand("jail", { "admin", "mod" }, function(admin, args)
    local targetName = args[1]
    local duration = tonumber(args[2]) or 0
    
    if not targetName then
        Sovereign.NotifyPlayer(admin, "Usage: !jail <player> [duration]")
        return
    end
    
    local target = Sovereign.GetPlayerByName(targetName)
    if not IsValid(target) then
        Sovereign.NotifyPlayer(admin, "Player not found: " .. targetName)
        return
    end
    
    -- Create jail prop
    local jailModel = Sovereign.Config.JailModel or "models/props_phx/construct/metal_plate1.mdl"
    local jailProp = ents.Create("prop_physics")
    jailProp:SetModel(jailModel)
    jailProp:SetPos(target:GetPos())
    jailProp:Spawn()
    jailProp:SetCollisionGroup(COLLISION_GROUP_WORLD)
    jailProp:SetMoveType(MOVETYPE_NONE)
    
    -- Store jail information
    Sovereign.JailedPlayers[target:SteamID()] = {
        entity = jailProp,
        time = CurTime(),
        duration = duration
    }
    
    -- Freeze the player
    target:Freeze(true)
    
    if duration > 0 then
        Sovereign.NotifyPlayer(admin, "Jailed " .. target:Nick() .. " for " .. duration .. " seconds")
        Sovereign.NotifyPlayer(target, "You have been jailed by " .. admin:Nick() .. " for " .. duration .. " seconds")
        
        -- Auto-unjail after duration
        timer.Simple(duration, function()
            if IsValid(target) and Sovereign.JailedPlayers[target:SteamID()] then
                local jailData = Sovereign.JailedPlayers[target:SteamID()]
                if IsValid(jailData.entity) then
                    jailData.entity:Remove()
                end
                target:Freeze(false)
                Sovereign.JailedPlayers[target:SteamID()] = nil
                Sovereign.NotifyPlayer(target, "You have been automatically unjailed")
            end
        end)
    else
        Sovereign.NotifyPlayer(admin, "Jailed " .. target:Nick() .. " indefinitely")
        Sovereign.NotifyPlayer(target, "You have been jailed by " .. admin:Nick())
    end
end, "Jail a player")

-- Unjail Command
Sovereign.RegisterCommand("unjail", { "admin", "mod" }, function(admin, args)
    local targetName = args[1]
    
    if not targetName then
        Sovereign.NotifyPlayer(admin, "Usage: !unjail <player>")
        return
    end
    
    local target = Sovereign.GetPlayerByName(targetName)
    if not IsValid(target) then
        Sovereign.NotifyPlayer(admin, "Player not found: " .. targetName)
        return
    end
    
    local jailData = Sovereign.JailedPlayers[target:SteamID()]
    if not jailData then
        Sovereign.NotifyPlayer(admin, target:Nick() .. " is not jailed")
        return
    end
    
    -- Remove jail entity
    if IsValid(jailData.entity) then
        jailData.entity:Remove()
    end
    
    -- Unfreeze player
    target:Freeze(false)
    Sovereign.JailedPlayers[target:SteamID()] = nil
    
    Sovereign.NotifyPlayer(admin, "Unjailed " .. target:Nick())
    Sovereign.NotifyPlayer(target, "You have been unjailed by " .. admin:Nick())
end, "Unjail a jailed player")

-- Exit Vehicle Command
Sovereign.RegisterCommand("exitvehicle", { "admin", "mod" }, function(admin, args)
    local targetName = args[1]
    
    if not targetName then
        Sovereign.NotifyPlayer(admin, "Usage: !exitvehicle <player>")
        return
    end
    
    local target = Sovereign.GetPlayerByName(targetName)
    if not IsValid(target) then
        Sovereign.NotifyPlayer(admin, "Player not found: " .. targetName)
        return
    end
    
    local vehicle = target:GetVehicle()
    if not IsValid(vehicle) then
        Sovereign.NotifyPlayer(admin, target:Nick() .. " is not in a vehicle")
        return
    end
    
    target:ExitVehicle()
    Sovereign.NotifyPlayer(admin, "Forced " .. target:Nick() .. " to exit vehicle")
    Sovereign.NotifyPlayer(target, "You were forced to exit vehicle by " .. admin:Nick())
end, "Force a player to exit their vehicle")

-- Give Ammo Command
Sovereign.RegisterCommand("giveammo", { "admin" }, function(admin, args)
    local targetName = args[1]
    local ammoType = args[2]
    local amount = tonumber(args[3]) or 100
    
    if not targetName or not ammoType then
        Sovereign.NotifyPlayer(admin, "Usage: !giveammo <player> <ammotype> [amount]")
        return
    end
    
    local target = Sovereign.GetPlayerByName(targetName)
    if not IsValid(target) then
        Sovereign.NotifyPlayer(admin, "Player not found: " .. targetName)
        return
    end
    
    target:GiveAmmo(amount, ammoType)
    Sovereign.NotifyPlayer(admin, "Gave " .. amount .. " " .. ammoType .. " ammo to " .. target:Nick())
    Sovereign.NotifyPlayer(target, "You received " .. amount .. " " .. ammoType .. " ammo from " .. admin:Nick())
end, "Give ammunition to a player")

-- Set Model Command
Sovereign.RegisterCommand("setmodel", { "admin" }, function(admin, args)
    local targetName = args[1]
    local model = args[2]
    
    if not targetName or not model then
        Sovereign.NotifyPlayer(admin, "Usage: !setmodel <player> <model>")
        return
    end
    
    local target = Sovereign.GetPlayerByName(targetName)
    if not IsValid(target) then
        Sovereign.NotifyPlayer(admin, "Player not found: " .. targetName)
        return
    end
    
    target:SetModel(model)
    Sovereign.NotifyPlayer(admin, "Set " .. target:Nick() .. "'s model to " .. model)
    Sovereign.NotifyPlayer(target, "Your model was set to " .. model .. " by " .. admin:Nick())
end, "Change a player's model")

-- Scale Command
Sovereign.RegisterCommand("scale", { "admin" }, function(admin, args)
    local targetName = args[1]
    local scale = tonumber(args[2]) or 1
    
    if not targetName then
        Sovereign.NotifyPlayer(admin, "Usage: !scale <player> <scale>")
        return
    end
    
    local target = Sovereign.GetPlayerByName(targetName)
    if not IsValid(target) then
        Sovereign.NotifyPlayer(admin, "Player not found: " .. targetName)
        return
    end
    
    target:SetModelScale(scale, 0.5)
    Sovereign.NotifyPlayer(admin, "Set " .. target:Nick() .. "'s scale to " .. scale)
    Sovereign.NotifyPlayer(target, "Your scale was set to " .. scale .. " by " .. admin:Nick())
end, "Change a player's scale")

print("[Sovereign] Fun commands loaded.")