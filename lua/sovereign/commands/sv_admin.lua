-- sv_admin.lua - Admin mode and role management commands for Sovereign Admin System

if not SERVER then return end

Sovereign = Sovereign or {}
Sovereign.AdminMode = Sovereign.AdminMode or {}

-- Track players in admin mode
local playersInAdminMode = {}
local previousStates = {}

-- Function to check if a player is in admin mode
function Sovereign.IsInAdminMode(ply)
    if not IsValid(ply) then return false end
    local steamID = ply:SteamID()
    return playersInAdminMode[steamID] == true
end

-- Admin Mode Toggle Command
Sovereign.RegisterCommand("adminmode", { "superadmin", "admin" }, function(admin, args)
    if not Sovereign.Config.AdminMode or not Sovereign.Config.AdminMode.Enabled then
        Sovereign.NotifyPlayer(admin, "Admin mode is not enabled on this server.")
        return
    end
    
    local steamID = admin:SteamID()
    local isInAdminMode = playersInAdminMode[steamID]
    
    if isInAdminMode then
        -- Disable admin mode
        Sovereign.DisableAdminMode(admin)
    else
        -- Enable admin mode
        Sovereign.EnableAdminMode(admin)
    end
end, "Toggle admin mode on/off")

-- Enable admin mode for a player
function Sovereign.EnableAdminMode(ply)
    if not IsValid(ply) then return end
    
    local steamID = ply:SteamID()
    local config = Sovereign.Config.AdminMode
    
    -- Save previous state
    previousStates[steamID] = {
        model = ply:GetModel(),
        health = ply:Health(),
        armor = ply:Armor(),
        walkSpeed = ply:GetWalkSpeed(),
        runSpeed = ply:GetRunSpeed(),
        jumpPower = ply:GetJumpPower(),
        godMode = ply:HasGodMode(),
        weapons = {}
    }
    
    -- Save weapons
    for _, wep in ipairs(ply:GetWeapons()) do
        table.insert(previousStates[steamID].weapons, wep:GetClass())
    end
    
    -- DarkRP job integration
    if DarkRP and config.DarkRP and config.DarkRP.Enabled and RPExtraTeams then
        previousStates[steamID].job = ply:getJobTable()
        previousStates[steamID].money = ply:getDarkRPVar("money")
        
        -- Find admin job
        local adminJob = nil
        for _, job in pairs(RPExtraTeams) do
            if job.name == config.DarkRP.AdminJobName then
                adminJob = job
                break
            end
        end
        
        if adminJob then
            ply:changeTeam(adminJob.team, true)
        end
    end
    
    -- Apply admin mode settings
    if config.Model then
        ply:SetModel(config.Model)
    end
    
    if config.Health then
        ply:SetHealth(config.Health)
    end
    
    if config.Armor then
        ply:SetArmor(config.Armor)
    end
    
    if config.GodMode then
        ply:GodEnable()
    end
    
    if config.Speed then
        ply:SetWalkSpeed(ply:GetWalkSpeed() * config.Speed)
        ply:SetRunSpeed(ply:GetRunSpeed() * config.Speed)
    end
    
    if config.JumpPower then
        ply:SetJumpPower(ply:GetJumpPower() * config.JumpPower)
    end
    
    if config.Cloak then
        ply:SetNoDraw(true)
        ply:SetNotSolid(true)
        ply:DrawWorldModel(false)
    end
    
    -- Play sound
    if config.Sounds and config.Sounds.Enable then
        ply:EmitSound(config.Sounds.Enable)
    end
    
    playersInAdminMode[steamID] = true
    
    Sovereign.NotifyPlayer(ply, "Admin mode enabled.")
    Sovereign.NotifyAdmins(ply:Nick() .. " entered admin mode.")
end

-- Disable admin mode for a player
function Sovereign.DisableAdminMode(ply)
    if not IsValid(ply) then return end
    
    local steamID = ply:SteamID()
    local config = Sovereign.Config.AdminMode
    local prevState = previousStates[steamID]
    
    if not prevState then return end
    
    -- Restore previous state
    if prevState.model then
        ply:SetModel(prevState.model)
    end
    
    if prevState.health then
        ply:SetHealth(prevState.health)
    end
    
    if prevState.armor then
        ply:SetArmor(prevState.armor)
    end
    
    if prevState.walkSpeed then
        ply:SetWalkSpeed(prevState.walkSpeed)
    end
    
    if prevState.runSpeed then
        ply:SetRunSpeed(prevState.runSpeed)
    end
    
    if prevState.jumpPower then
        ply:SetJumpPower(prevState.jumpPower)
    end
    
    if not prevState.godMode then
        ply:GodDisable()
    end
    
    -- Restore visibility
    ply:SetNoDraw(false)
    ply:SetNotSolid(false)
    ply:DrawWorldModel(true)
    
    -- Strip admin weapons and restore previous weapons
    ply:StripWeapons()
    if config.DarkRP and config.DarkRP.RememberWeapons and prevState.weapons then
        for _, wepClass in ipairs(prevState.weapons) do
            ply:Give(wepClass)
        end
    end
    
    -- DarkRP job restoration
    if DarkRP and config.DarkRP and config.DarkRP.Enabled and config.DarkRP.RememberJob then
        if prevState.job then
            ply:changeTeam(prevState.job.team, true)
        end
    end
    
    -- Play sound
    if config.Sounds and config.Sounds.Disable then
        ply:EmitSound(config.Sounds.Disable)
    end
    
    playersInAdminMode[steamID] = nil
    previousStates[steamID] = nil
    
    Sovereign.NotifyPlayer(ply, "Admin mode disabled.")
    Sovereign.NotifyAdmins(ply:Nick() .. " left admin mode.")
end

-- Add Role Command
Sovereign.RegisterCommand("addrole", { "superadmin" }, function(admin, args)
    local targetName = args[1]
    local roleName = args[2]
    
    if not targetName or not roleName then
        Sovereign.NotifyPlayer(admin, "Usage: !addrole <player> <role>")
        return
    end
    
    local target = Sovereign.GetPlayerByName(targetName)
    if not IsValid(target) then
        Sovereign.NotifyPlayer(admin, "Player not found: " .. targetName)
        return
    end
    
    -- Check if role is valid
    if not table.HasValue(Sovereign.Roles.AvailableRoles, roleName) then
        Sovereign.NotifyPlayer(admin, "Invalid role: " .. roleName)
        Sovereign.NotifyPlayer(admin, "Available roles: " .. table.concat(Sovereign.Roles.AvailableRoles, ", "))
        return
    end
    
    -- Add role to hierarchy if it doesn't exist
    if not Sovereign.Roles.Hierarchy[roleName] then
        Sovereign.AddRoleToHierarchy(roleName, {})
    end
    
    -- Add role to player
    local success = Sovereign.AddPlayerRole(target, roleName)
    
    if success then
        Sovereign.NotifyPlayer(admin, "Added role '" .. roleName .. "' to " .. target:Nick())
        Sovereign.NotifyPlayer(target, "You have been given the '" .. roleName .. "' role by " .. admin:Nick())
        Sovereign.NotifyAdmins(admin:Nick() .. " added role '" .. roleName .. "' to " .. target:Nick())
    else
        Sovereign.NotifyPlayer(admin, target:Nick() .. " already has the '" .. roleName .. "' role.")
    end
end, "Add a role to a player")

-- Remove Role Command
Sovereign.RegisterCommand("removerole", { "superadmin" }, function(admin, args)
    local targetName = args[1]
    local roleName = args[2]
    
    if not targetName or not roleName then
        Sovereign.NotifyPlayer(admin, "Usage: !removerole <player> <role>")
        return
    end
    
    local target = Sovereign.GetPlayerByName(targetName)
    if not IsValid(target) then
        Sovereign.NotifyPlayer(admin, "Player not found: " .. targetName)
        return
    end
    
    -- Remove role from player
    local success = Sovereign.RemovePlayerRole(target, roleName)
    
    if success then
        Sovereign.NotifyPlayer(admin, "Removed role '" .. roleName .. "' from " .. target:Nick())
        Sovereign.NotifyPlayer(target, "Your '" .. roleName .. "' role has been removed by " .. admin:Nick())
        Sovereign.NotifyAdmins(admin:Nick() .. " removed role '" .. roleName .. "' from " .. target:Nick())
    else
        Sovereign.NotifyPlayer(admin, target:Nick() .. " doesn't have the '" .. roleName .. "' role.")
    end
end, "Remove a role from a player")

-- List Roles Command
Sovereign.RegisterCommand("listroles", { "superadmin", "admin" }, function(admin, args)
    local targetName = args[1]
    
    if not targetName then
        -- List available roles
        Sovereign.NotifyPlayer(admin, "Available roles: " .. table.concat(Sovereign.Roles.AvailableRoles, ", "))
        return
    end
    
    local target = Sovereign.GetPlayerByName(targetName)
    if not IsValid(target) then
        Sovereign.NotifyPlayer(admin, "Player not found: " .. targetName)
        return
    end
    
    -- Get player's roles
    local roles = Sovereign.GetPlayerRoles(target)
    
    if #roles > 0 then
        Sovereign.NotifyPlayer(admin, target:Nick() .. "'s roles: " .. table.concat(roles, ", "))
    else
        Sovereign.NotifyPlayer(admin, target:Nick() .. " has no additional roles.")
    end
end, "List roles for a player or all available roles")

-- Clean up on player disconnect
hook.Add("PlayerDisconnected", "Sovereign_AdminMode_Cleanup", function(ply)
    local steamID = ply:SteamID()
    playersInAdminMode[steamID] = nil
    previousStates[steamID] = nil
end)

-- Key bind for admin mode toggle
if Sovereign.Config.AdminMode and Sovereign.Config.AdminMode.ToggleKey then
    hook.Add("PlayerButtonDown", "Sovereign_AdminMode_KeyBind", function(ply, button)
        if button == Sovereign.Config.AdminMode.ToggleKey then
            if Sovereign.PlayerHasRole(ply, "admin") or Sovereign.PlayerHasRole(ply, "superadmin") then
                if Sovereign.Config.AdminMode.Enabled then
                    local steamID = ply:SteamID()
                    if playersInAdminMode[steamID] then
                        Sovereign.DisableAdminMode(ply)
                    else
                        Sovereign.EnableAdminMode(ply)
                    end
                end
            end
        end
    end)
end

print("[Sovereign] Admin mode and role management commands loaded.")
