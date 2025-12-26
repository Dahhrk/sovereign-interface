local roles = {
    superadmin = { inherit = { "admin" } },
    admin = { inherit = { "mod" } },
    mod = { inherit = { "user" } },
    user = {}
}

function HasPermission(role, command)
    local roleData = roles[role]
    if roleData.inherit then
        for _, parentRole in ipairs(roleData.inherit) do
            if HasPermission(parentRole, command) then return true end
        end
    end
    return roleData[command] or false
end