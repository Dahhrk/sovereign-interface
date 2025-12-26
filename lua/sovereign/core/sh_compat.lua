-- sh_compat.lua - Compatibility layer for external systems (CAMI, bLogs, etc.)

Sovereign = Sovereign or {}
Sovereign.Compat = Sovereign.Compat or {}

-- ===============================
-- CAMI (Common Admin Mod Interface) Support
-- ===============================

if CAMI then
    print("[Sovereign] CAMI detected, registering compatibility...")
    
    -- Register Sovereign as a CAMI provider
    CAMI.RegisterPrivilege({
        Name = "Sovereign Admin",
        MinAccess = "admin"
    })
    
    -- Register all Sovereign roles with CAMI (check if roles exist first)
    if Sovereign.Roles and Sovereign.Roles.Hierarchy then
        for roleName, roleData in pairs(Sovereign.Roles.Hierarchy) do
            CAMI.RegisterUsergroup({
                Name = roleName,
                Inherits = roleData.inherit or {}
            }, "Sovereign")
        end
    end
    
    -- Hook into CAMI's permission system
    function Sovereign.Compat.CAMI_CheckPermission(ply, permission)
        return CAMI.PlayerHasAccess(ply, permission, nil)
    end
    
    print("[Sovereign] CAMI compatibility enabled.")
end

-- ===============================
-- bLogs / mLogs Integration
-- ===============================

-- Check if bLogs is present
if blog then
    print("[Sovereign] bLogs detected, enabling integration...")
    
    Sovereign.Compat.bLogs = true
    
    -- Function to log actions to bLogs
    function Sovereign.Compat.LogToBLogs(admin, action, target, extra)
        if not blog then return end
        
        local category = "Sovereign Admin"
        local message = string.format("%s used %s on %s", 
            admin:Nick(), 
            action, 
            IsValid(target) and target:Nick() or tostring(target)
        )
        
        if extra then
            message = message .. " (" .. extra .. ")"
        end
        
        blog.addLog(category, admin, target, message)
    end
else
    Sovereign.Compat.bLogs = false
end

-- Check if mLogs is present
if mlog then
    print("[Sovereign] mLogs detected, enabling integration...")
    
    Sovereign.Compat.mLogs = true
    
    -- Function to log actions to mLogs
    function Sovereign.Compat.LogToMLogs(admin, action, target, extra)
        if not mlog then return end
        
        local message = string.format("%s used %s on %s", 
            admin:Nick(), 
            action, 
            IsValid(target) and target:Nick() or tostring(target)
        )
        
        if extra then
            message = message .. " (" .. extra .. ")"
        end
        
        mlog.log(admin, action, message)
    end
else
    Sovereign.Compat.mLogs = false
end

-- Unified logging function that works with both bLogs and mLogs
function Sovereign.Compat.LogAction(admin, action, target, extra)
    if Sovereign.Compat.bLogs then
        Sovereign.Compat.LogToBLogs(admin, action, target, extra)
    end
    
    if Sovereign.Compat.mLogs then
        Sovereign.Compat.LogToMLogs(admin, action, target, extra)
    end
end

-- ===============================
-- UI-Ready Hooks for Future GUI
-- ===============================

Sovereign.Compat.UI = Sovereign.Compat.UI or {}
Sovereign.Compat.UI.Hooks = {}

-- Register a UI hook
function Sovereign.Compat.UI.RegisterHook(hookName, callback)
    if not Sovereign.Compat.UI.Hooks[hookName] then
        Sovereign.Compat.UI.Hooks[hookName] = {}
    end
    
    table.insert(Sovereign.Compat.UI.Hooks[hookName], callback)
end

-- Call UI hooks
function Sovereign.Compat.UI.CallHook(hookName, ...)
    if not Sovereign.Compat.UI.Hooks[hookName] then return end
    
    for _, callback in ipairs(Sovereign.Compat.UI.Hooks[hookName]) do
        local success, err = pcall(callback, ...)
        if not success then
            print("[Sovereign] UI Hook error in " .. hookName .. ": " .. tostring(err))
        end
    end
end

-- Predefined UI hooks for common events
-- These can be used by future GUI implementations

-- Called when a player opens the admin menu
function Sovereign.Compat.UI.OnAdminMenuOpen(ply)
    Sovereign.Compat.UI.CallHook("AdminMenuOpen", ply)
end

-- Called when a command is executed
function Sovereign.Compat.UI.OnCommandExecute(admin, commandName, args, target)
    Sovereign.Compat.UI.CallHook("CommandExecute", admin, commandName, args, target)
end

-- Called when a player's role changes
function Sovereign.Compat.UI.OnRoleChange(ply, role, added)
    Sovereign.Compat.UI.CallHook("RoleChange", ply, role, added)
end

-- Called when admin mode is toggled
function Sovereign.Compat.UI.OnAdminModeToggle(ply, enabled)
    Sovereign.Compat.UI.CallHook("AdminModeToggle", ply, enabled)
end

-- Called when a player is banned
function Sovereign.Compat.UI.OnPlayerBan(admin, target, duration, reason)
    Sovereign.Compat.UI.CallHook("PlayerBan", admin, target, duration, reason)
end

-- Called when a player is kicked
function Sovereign.Compat.UI.OnPlayerKick(admin, target, reason)
    Sovereign.Compat.UI.CallHook("PlayerKick", admin, target, reason)
end

-- Example usage for future GUI developers:
--[[
    Sovereign.Compat.UI.RegisterHook("AdminMenuOpen", function(ply)
        -- Open custom admin menu for player
        net.Start("OpenSovereignMenu")
        net.Send(ply)
    end)
]]

print("[Sovereign] Compatibility layer loaded.")
print("[Sovereign] bLogs: " .. tostring(Sovereign.Compat.bLogs))
print("[Sovereign] mLogs: " .. tostring(Sovereign.Compat.mLogs))
print("[Sovereign] CAMI: " .. tostring(CAMI ~= nil))
