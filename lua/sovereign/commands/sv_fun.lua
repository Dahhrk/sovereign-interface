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
    
    -- Apply upward velocity for slap effect
    local velocity = target:GetVelocity()
    target:SetVelocity(Vector(math.random(-100, 100), math.random(-100, 100), 200))
    
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

print("[Sovereign] Fun commands loaded.")