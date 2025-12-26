-- sh_core.lua - Core functionality for Sovereign Admin System

Sovereign = Sovereign or {}
Sovereign.Commands = Sovereign.Commands or {}
Sovereign.Config = Sovereign.Config or {}

-- Helper function to get player by name or partial name
function Sovereign.GetPlayerByName(name)
    if not name then return nil end
    
    name = string.lower(name)
    
    -- Check for exact match first
    for _, ply in ipairs(player.GetAll()) do
        if string.lower(ply:Nick()) == name then
            return ply
        end
    end
    
    -- Check for partial match
    for _, ply in ipairs(player.GetAll()) do
        if string.find(string.lower(ply:Nick()), name, 1, true) then
            return ply
        end
    end
    
    return nil
end

-- Helper function to check if player has permission for a command
function Sovereign.HasPermission(ply, commandName)
    if not IsValid(ply) then return false end
    
    local cmd = Sovereign.Commands[commandName]
    if not cmd then return false end
    
    -- Check if player's usergroup is in the allowed roles
    local usergroup = ply:GetUserGroup()
    
    for _, role in ipairs(cmd.roles) do
        if Sovereign.CheckRole(usergroup, role) then
            return true
        end
    end
    
    return false
end

-- Helper function to notify a single admin
function Sovereign.NotifyPlayer(ply, message)
    if not IsValid(ply) then return end
    
    if SERVER then
        ply:ChatPrint("[Sovereign] " .. message)
    end
end

-- Helper function to notify all admins
function Sovereign.NotifyAdmins(message)
    if SERVER then
        for _, ply in ipairs(player.GetAll()) do
            if ply:IsAdmin() or ply:IsSuperAdmin() then
                ply:ChatPrint("[Sovereign] " .. message)
            end
        end
    end
end

-- Function to register a command
function Sovereign.RegisterCommand(name, roles, callback, description)
    Sovereign.Commands[name] = {
        name = name,
        roles = roles,
        callback = callback,
        description = description or "No description provided"
    }
    
    if SERVER then
        print("[Sovereign] Registered command: " .. name)
    end
end

-- Function to execute a command
function Sovereign.ExecuteCommand(ply, commandName, args)
    if not IsValid(ply) then return end
    
    local cmd = Sovereign.Commands[commandName]
    if not cmd then
        Sovereign.NotifyPlayer(ply, "Command not found: " .. commandName)
        return
    end
    
    -- Check permissions
    if not Sovereign.HasPermission(ply, commandName) then
        Sovereign.NotifyPlayer(ply, "You don't have permission to use this command.")
        return
    end
    
    -- Log the command execution
    Sovereign.LogCommand(ply, commandName, args)
    
    -- Execute the callback
    local success, err = pcall(cmd.callback, ply, args)
    if not success then
        Sovereign.NotifyPlayer(ply, "Error executing command: " .. tostring(err))
        print("[Sovereign] Error in command " .. commandName .. ": " .. tostring(err))
    end
end

-- Function to log command execution
function Sovereign.LogCommand(ply, commandName, args)
    if not SERVER then return end
    
    local logMessage = string.format(
        "[Sovereign] %s (%s) executed: %s %s",
        ply:Nick(),
        ply:SteamID(),
        commandName,
        table.concat(args or {}, " ")
    )
    
    print(logMessage)
    
    -- Store in database if available
    if Sovereign.Database and Sovereign.Database.LogAction then
        Sovereign.Database.LogAction(ply:SteamID(), commandName, table.concat(args or {}, " "))
    end
end

-- Chat hook to process commands
if SERVER then
    hook.Add("PlayerSay", "Sovereign_CommandProcessor", function(ply, text)
        local prefix = Sovereign.Config.Prefix or "!"
        
        if string.sub(text, 1, #prefix) ~= prefix then
            return
        end
        
        -- Remove prefix and split into command and arguments
        local commandString = string.sub(text, #prefix + 1)
        local args = string.Explode(" ", commandString)
        local commandName = string.lower(table.remove(args, 1) or "")
        
        if commandName == "" then return end
        
        -- Execute the command
        Sovereign.ExecuteCommand(ply, commandName, args)
        
        return "" -- Suppress the message from chat
    end)
end

print("[Sovereign] Core system loaded.")
