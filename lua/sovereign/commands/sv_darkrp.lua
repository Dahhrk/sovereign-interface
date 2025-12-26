-- sv_darkrp.lua - DarkRP-specific commands for Sovereign Admin System

if not SERVER then return end

Sovereign = Sovereign or {}
Sovereign.JailPositions = Sovereign.JailPositions or {}

-- Check if DarkRP is loaded
local function IsDarkRP()
    return DarkRP ~= nil
end

-- Arrest Command
Sovereign.RegisterCommand("arrest", { "admin", "mod" }, function(admin, args)
    local targetName = args[1]
    local duration = tonumber(args[2]) or 120
    
    if not targetName then
        Sovereign.NotifyPlayer(admin, "Usage: !arrest <player> [duration]")
        return
    end
    
    if not IsDarkRP() then
        Sovereign.NotifyPlayer(admin, "This command requires DarkRP")
        return
    end
    
    local target = Sovereign.GetPlayerByName(targetName)
    if not IsValid(target) then
        Sovereign.NotifyPlayer(admin, "Player not found: " .. targetName)
        return
    end
    
    -- Use DarkRP arrest function if available
    if target.arrest then
        target:arrest(duration, admin)
        Sovereign.NotifyPlayer(admin, "Arrested " .. target:Nick() .. " for " .. duration .. " seconds")
        Sovereign.NotifyPlayer(target, "You have been arrested by " .. admin:Nick())
    else
        Sovereign.NotifyPlayer(admin, "DarkRP arrest function not available")
    end
end, "Arrest a player (DarkRP)")

-- Unarrest Command
Sovereign.RegisterCommand("unarrest", { "admin", "mod" }, function(admin, args)
    local targetName = args[1]
    
    if not targetName then
        Sovereign.NotifyPlayer(admin, "Usage: !unarrest <player>")
        return
    end
    
    if not IsDarkRP() then
        Sovereign.NotifyPlayer(admin, "This command requires DarkRP")
        return
    end
    
    local target = Sovereign.GetPlayerByName(targetName)
    if not IsValid(target) then
        Sovereign.NotifyPlayer(admin, "Player not found: " .. targetName)
        return
    end
    
    -- Use DarkRP unarrest function if available
    if target.unArrest then
        target:unArrest()
        Sovereign.NotifyPlayer(admin, "Unarrested " .. target:Nick())
        Sovereign.NotifyPlayer(target, "You have been unarrested by " .. admin:Nick())
    else
        Sovereign.NotifyPlayer(admin, "DarkRP unarrest function not available")
    end
end, "Unarrest a player (DarkRP)")

-- Set Money Command
Sovereign.RegisterCommand("setmoney", { "admin" }, function(admin, args)
    local targetName = args[1]
    local amount = tonumber(args[2])
    
    if not targetName or not amount then
        Sovereign.NotifyPlayer(admin, "Usage: !setmoney <player> <amount>")
        return
    end
    
    if not IsDarkRP() then
        Sovereign.NotifyPlayer(admin, "This command requires DarkRP")
        return
    end
    
    local target = Sovereign.GetPlayerByName(targetName)
    if not IsValid(target) then
        Sovereign.NotifyPlayer(admin, "Player not found: " .. targetName)
        return
    end
    
    -- Use DarkRP money functions
    if target.setDarkRPVar then
        target:setDarkRPVar("money", amount)
        Sovereign.NotifyPlayer(admin, "Set " .. target:Nick() .. "'s money to " .. DarkRP.formatMoney(amount))
        Sovereign.NotifyPlayer(target, "Your money was set to " .. DarkRP.formatMoney(amount) .. " by " .. admin:Nick())
    else
        Sovereign.NotifyPlayer(admin, "DarkRP money functions not available")
    end
end, "Set a player's money (DarkRP)")

-- Add Money Command
Sovereign.RegisterCommand("addmoney", { "admin" }, function(admin, args)
    local targetName = args[1]
    local amount = tonumber(args[2])
    
    if not targetName or not amount then
        Sovereign.NotifyPlayer(admin, "Usage: !addmoney <player> <amount>")
        return
    end
    
    if not IsDarkRP() then
        Sovereign.NotifyPlayer(admin, "This command requires DarkRP")
        return
    end
    
    local target = Sovereign.GetPlayerByName(targetName)
    if not IsValid(target) then
        Sovereign.NotifyPlayer(admin, "Player not found: " .. targetName)
        return
    end
    
    -- Use DarkRP money functions
    if target.addMoney then
        target:addMoney(amount)
        Sovereign.NotifyPlayer(admin, "Added " .. DarkRP.formatMoney(amount) .. " to " .. target:Nick())
        Sovereign.NotifyPlayer(target, "You received " .. DarkRP.formatMoney(amount) .. " from " .. admin:Nick())
    else
        Sovereign.NotifyPlayer(admin, "DarkRP money functions not available")
    end
end, "Add money to a player (DarkRP)")

-- Sell Door Command
Sovereign.RegisterCommand("selldoor", { "admin", "mod" }, function(admin, args)
    local targetName = args[1]
    
    if not targetName then
        Sovereign.NotifyPlayer(admin, "Usage: !selldoor <player>")
        return
    end
    
    if not IsDarkRP() then
        Sovereign.NotifyPlayer(admin, "This command requires DarkRP")
        return
    end
    
    local target = Sovereign.GetPlayerByName(targetName)
    if not IsValid(target) then
        Sovereign.NotifyPlayer(admin, "Player not found: " .. targetName)
        return
    end
    
    -- Get the door the admin is looking at
    local trace = admin:GetEyeTrace()
    if not IsValid(trace.Entity) or not trace.Entity:isDoor() then
        Sovereign.NotifyPlayer(admin, "You must be looking at a door")
        return
    end
    
    local door = trace.Entity
    
    -- Sell the door
    if door.removeOwner then
        door:removeOwner()
        Sovereign.NotifyPlayer(admin, "Sold " .. target:Nick() .. "'s door")
        Sovereign.NotifyPlayer(target, "Your door was sold by " .. admin:Nick())
    else
        Sovereign.NotifyPlayer(admin, "DarkRP door functions not available")
    end
end, "Sell a player's door (DarkRP)")

-- Sell All Doors Command
Sovereign.RegisterCommand("sellall", { "admin", "mod" }, function(admin, args)
    local targetName = args[1]
    
    if not targetName then
        Sovereign.NotifyPlayer(admin, "Usage: !sellall <player>")
        return
    end
    
    if not IsDarkRP() then
        Sovereign.NotifyPlayer(admin, "This command requires DarkRP")
        return
    end
    
    local target = Sovereign.GetPlayerByName(targetName)
    if not IsValid(target) then
        Sovereign.NotifyPlayer(admin, "Player not found: " .. targetName)
        return
    end
    
    -- Sell all doors owned by the player
    local doorCount = 0
    for _, ent in ipairs(ents.GetAll()) do
        if ent:isDoor() and ent:getOwner() == target then
            if ent.removeOwner then
                ent:removeOwner()
                doorCount = doorCount + 1
            end
        end
    end
    
    Sovereign.NotifyPlayer(admin, "Sold " .. doorCount .. " doors owned by " .. target:Nick())
    if doorCount > 0 then
        Sovereign.NotifyPlayer(target, admin:Nick() .. " sold all your doors (" .. doorCount .. ")")
    end
end, "Sell all doors owned by a player (DarkRP)")

-- Set Jail Position Command
Sovereign.RegisterCommand("setjailpos", { "superadmin", "admin" }, function(admin, args)
    local pos = admin:GetPos()
    local ang = admin:EyeAngles()
    
    -- Clear existing positions and set new one
    Sovereign.JailPositions = {
        {
            pos = pos,
            ang = Angle(0, ang.y, 0)
        }
    }
    
    -- Save to database
    if Sovereign.Database and Sovereign.Database.SetJailPositions then
        Sovereign.Database.SetJailPositions(Sovereign.JailPositions)
    end
    
    Sovereign.NotifyPlayer(admin, "Set jail position at your current location")
    Sovereign.NotifyAdmins(admin:Nick() .. " set the jail position")
end, "Set the jail spawn position")

-- Add Jail Position Command
Sovereign.RegisterCommand("addjailpos", { "superadmin", "admin" }, function(admin, args)
    local pos = admin:GetPos()
    local ang = admin:EyeAngles()
    
    -- Add to existing positions
    table.insert(Sovereign.JailPositions, {
        pos = pos,
        ang = Angle(0, ang.y, 0)
    })
    
    -- Save to database
    if Sovereign.Database and Sovereign.Database.SetJailPositions then
        Sovereign.Database.SetJailPositions(Sovereign.JailPositions)
    end
    
    Sovereign.NotifyPlayer(admin, "Added jail position #" .. #Sovereign.JailPositions .. " at your current location")
    Sovereign.NotifyAdmins(admin:Nick() .. " added a jail position")
end, "Add a jail spawn position")

print("[Sovereign] DarkRP commands loaded.")
