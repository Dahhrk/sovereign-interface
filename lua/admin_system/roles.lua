-- admin_system/roles.lua
local roles = {
    superadmin = { inherit = { "admin" } },
    admin = { inherit = { "mod" } },
    mod = { inherit = { "user" } },
    user = {}
}

-- Check role permissions
function HasPermission(role, command)
    local roleData = roles[role]
    if roleData.inherit then
        for _, inheritedRole in ipairs(roleData.inherit) do
            if HasPermission(inheritedRole, command) then return true end
        end
    end
    return roleData[command] or false
end