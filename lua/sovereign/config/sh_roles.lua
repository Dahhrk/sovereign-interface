-- sh_roles.lua - Role and permission management for Sovereign Admin System

Sovereign = Sovereign or {}
Sovereign.Roles = Sovereign.Roles or {}
Sovereign.PlayerRoles = Sovereign.PlayerRoles or {}

-- Define role hierarchy with inheritance
-- By default, only superadmin is included; other roles must be added manually
Sovereign.Roles.Hierarchy = {
    superadmin = {}  -- Superadmin only by default as per requirements
}

-- Default available roles that can be added dynamically
Sovereign.Roles.AvailableRoles = {
    "superadmin",
    "admin",
    "mod",
    "vip",
    "trusted",
    "user"
}

-- Check if a role has access to another role (through inheritance)
function Sovereign.CheckRole(userRole, requiredRole)
    if userRole == requiredRole then
        return true
    end
    
    local roleData = Sovereign.Roles.Hierarchy[userRole]
    if not roleData then return false end
    
    -- Check inherited roles
    if roleData.inherit then
        for _, parentRole in ipairs(roleData.inherit) do
            if Sovereign.CheckRole(parentRole, requiredRole) then
                return true
            end
        end
    end
    
    return false
end

-- Get all permissions for a role (including inherited)
function Sovereign.GetRolePermissions(role)
    local permissions = {}
    local roleData = Sovereign.Roles.Hierarchy[role]
    
    if not roleData then return permissions end
    
    -- Add inherited permissions
    if roleData.inherit then
        for _, parentRole in ipairs(roleData.inherit) do
            local parentPerms = Sovereign.GetRolePermissions(parentRole)
            for _, perm in ipairs(parentPerms) do
                table.insert(permissions, perm)
            end
        end
    end
    
    return permissions
end

-- Check if a player has a specific role (supports multi-role system)
function Sovereign.PlayerHasRole(ply, role)
    if not IsValid(ply) then return false end
    
    local steamID = ply:SteamID()
    
    -- Check player's custom roles first (multi-role system)
    if Sovereign.PlayerRoles[steamID] then
        for _, playerRole in ipairs(Sovereign.PlayerRoles[steamID]) do
            if Sovereign.CheckRole(playerRole, role) then
                return true
            end
        end
    end
    
    -- Fall back to GMod usergroup
    local usergroup = ply:GetUserGroup()
    return Sovereign.CheckRole(usergroup, role)
end

-- Get all roles for a player
function Sovereign.GetPlayerRoles(ply)
    if not IsValid(ply) then return {} end
    
    local steamID = ply:SteamID()
    local roles = {}
    
    -- Add custom roles
    if Sovereign.PlayerRoles[steamID] then
        for _, role in ipairs(Sovereign.PlayerRoles[steamID]) do
            table.insert(roles, role)
        end
    end
    
    -- Add GMod usergroup
    local usergroup = ply:GetUserGroup()
    if not table.HasValue(roles, usergroup) then
        table.insert(roles, usergroup)
    end
    
    return roles
end

-- Add a role to a player (multi-role support)
function Sovereign.AddPlayerRole(ply, role)
    if not IsValid(ply) then return false end
    
    local steamID = ply:SteamID()
    
    -- Initialize player roles if not exists
    if not Sovereign.PlayerRoles[steamID] then
        Sovereign.PlayerRoles[steamID] = {}
    end
    
    -- Check if player already has the role
    if table.HasValue(Sovereign.PlayerRoles[steamID], role) then
        return false
    end
    
    -- Add the role
    table.insert(Sovereign.PlayerRoles[steamID], role)
    
    -- Save to database if available
    if SERVER and Sovereign.Database and Sovereign.Database.SavePlayerRole then
        Sovereign.Database.SavePlayerRole(steamID, role)
    end
    
    return true
end

-- Remove a role from a player
function Sovereign.RemovePlayerRole(ply, role)
    if not IsValid(ply) then return false end
    
    local steamID = ply:SteamID()
    
    if not Sovereign.PlayerRoles[steamID] then
        return false
    end
    
    -- Find and remove the role
    for i, playerRole in ipairs(Sovereign.PlayerRoles[steamID]) do
        if playerRole == role then
            table.remove(Sovereign.PlayerRoles[steamID], i)
            
            -- Remove from database if available
            if SERVER and Sovereign.Database and Sovereign.Database.RemovePlayerRole then
                Sovereign.Database.RemovePlayerRole(steamID, role)
            end
            
            return true
        end
    end
    
    return false
end

-- Add a role to the hierarchy dynamically
function Sovereign.AddRoleToHierarchy(roleName, inheritRoles)
    if Sovereign.Roles.Hierarchy[roleName] then
        return false -- Role already exists
    end
    
    Sovereign.Roles.Hierarchy[roleName] = {
        inherit = inheritRoles or {}
    }
    
    return true
end

-- Remove a role from the hierarchy
function Sovereign.RemoveRoleFromHierarchy(roleName)
    if not Sovereign.Roles.Hierarchy[roleName] then
        return false
    end
    
    Sovereign.Roles.Hierarchy[roleName] = nil
    return true
end

print("[Sovereign] Role management loaded.")
