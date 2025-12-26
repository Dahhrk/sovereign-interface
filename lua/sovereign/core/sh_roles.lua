-- sh_roles.lua - Role and permission management for Sovereign Admin System

Sovereign = Sovereign or {}
Sovereign.Roles = Sovereign.Roles or {}

-- Define role hierarchy with inheritance
Sovereign.Roles.Hierarchy = {
    superadmin = { inherit = { "admin" } },
    admin = { inherit = { "mod" } },
    mod = { inherit = { "user" } },
    user = {}
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

-- Check if a player has a specific role
function Sovereign.PlayerHasRole(ply, role)
    if not IsValid(ply) then return false end
    
    local usergroup = ply:GetUserGroup()
    return Sovereign.CheckRole(usergroup, role)
end

print("[Sovereign] Role management loaded.")