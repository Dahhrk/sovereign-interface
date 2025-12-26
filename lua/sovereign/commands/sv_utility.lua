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

print("[Sovereign] Utility commands loaded.")
