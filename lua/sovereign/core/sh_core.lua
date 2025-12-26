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
    
    -- Get all player roles (including multi-role assignments)
    local playerRoles = Sovereign.GetPlayerRoles(ply)
    
    -- Check if any of the player's roles has access
    for _, playerRole in ipairs(playerRoles) do
        for _, requiredRole in ipairs(cmd.roles) do
            if Sovereign.CheckRole(playerRole, requiredRole) then
                return true
            end
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
            -- Check if player has admin or higher role using the role system
            if Sovereign.PlayerHasRole(ply, "mod") then
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
function Sovereign.ExecuteCommand(ply, commandName, args, isSilent)
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
    
    -- Check admin mode requirement if restrictions are enabled
    if SERVER and Sovereign.Config.AdminMode and Sovereign.Config.AdminMode.RestrictCommands then
        -- Get command config from centralized config
        local cmdConfig = Sovereign.Config.Commands and Sovereign.Config.Commands[commandName]
        
        -- Check if command requires admin mode
        if cmdConfig and cmdConfig.adminMode and Sovereign.IsInAdminMode then
            -- Check if player is in admin mode
            if not Sovereign.IsInAdminMode(ply) then
                Sovereign.NotifyPlayer(ply, "You must enable Admin Mode to use this command. Use !adminmode to toggle.")
                return
            end
        end
    end
    
    -- Log the command execution
    Sovereign.LogCommand(ply, commandName, args, isSilent)
    
    -- Execute the callback
    local success, err = pcall(cmd.callback, ply, args)
    if not success then
        Sovereign.NotifyPlayer(ply, "Error executing command: " .. tostring(err))
        print("[Sovereign] Error in command " .. commandName .. ": " .. tostring(err))
    end
end

-- Function to log command execution
function Sovereign.LogCommand(ply, commandName, args, isSilent)
    if not SERVER then return end
    
    local logMessage = string.format(
        "[Sovereign] %s (%s) executed: %s %s",
        ply:Nick(),
        ply:SteamID(),
        commandName,
        table.concat(args or {}, " ")
    )
    
    -- Always print to server console
    print(logMessage)
    
    -- Store in database if available
    if Sovereign.Database and Sovereign.Database.LogAction then
        Sovereign.Database.LogAction(ply:SteamID(), commandName, table.concat(args or {}, " "))
    end
    
    -- Log to bLogs/mLogs if available
    if Sovereign.Compat and Sovereign.Compat.LogAction then
        local target = nil
        if args and args[1] then
            target = Sovereign.GetPlayerByName(args[1])
        end
        
        Sovereign.Compat.LogAction(ply, commandName, target, table.concat(args or {}, " "))
    end
    
    -- Notify admins of action if enabled and not silent
    if Sovereign.Config.Chat and Sovereign.Config.Chat.AdminLogsVisibleToStaff then
        if not isSilent then
            -- Format a user-friendly action message
            local actionMessage = Sovereign.FormatAdminAction(ply, commandName, args)
            if actionMessage then
                Sovereign.NotifyAdminsAction(actionMessage)
            end
        else
            -- For silent commands, only notify the issuer
            local actionMessage = Sovereign.FormatAdminAction(ply, commandName, args)
            if actionMessage then
                ply:ChatPrint("[Silent] " .. actionMessage)
            end
        end
    end
end

-- Helper function to format admin action messages
function Sovereign.FormatAdminAction(ply, commandName, args)
    if not IsValid(ply) then return nil end
    
    local targetName = args and args[1] or nil
    
    -- Format message based on command type
    if commandName == "ban" then
        local duration = args[2] or "permanent"
        local reason = (#args >= 3 and table.concat(args, " ", 3)) or "No reason"
        return ply:Nick() .. " banned " .. (targetName or "unknown") .. " for " .. duration .. ". Reason: " .. reason
    elseif commandName == "kick" then
        local reason = (#args >= 2 and table.concat(args, " ", 2)) or "No reason"
        return ply:Nick() .. " kicked " .. (targetName or "unknown") .. ". Reason: " .. reason
    elseif commandName == "warn" then
        local reason = (#args >= 2 and table.concat(args, " ", 2)) or "No reason"
        return ply:Nick() .. " warned " .. (targetName or "unknown") .. ". Reason: " .. reason
    elseif commandName == "freeze" then
        return ply:Nick() .. " froze " .. (targetName or "unknown")
    elseif commandName == "unfreeze" then
        return ply:Nick() .. " unfroze " .. (targetName or "unknown")
    elseif commandName == "slay" then
        return ply:Nick() .. " slayed " .. (targetName or "unknown")
    elseif commandName == "jail" then
        local duration = args[2] or "indefinitely"
        return ply:Nick() .. " jailed " .. (targetName or "unknown") .. " for " .. duration
    elseif commandName == "unjail" then
        return ply:Nick() .. " unjailed " .. (targetName or "unknown")
    elseif commandName == "mute" then
        local duration = args[2] or "indefinitely"
        return ply:Nick() .. " muted " .. (targetName or "unknown") .. " for " .. duration
    elseif commandName == "unmute" then
        return ply:Nick() .. " unmuted " .. (targetName or "unknown")
    elseif commandName == "gag" then
        local duration = args[2] or "indefinitely"
        return ply:Nick() .. " gagged " .. (targetName or "unknown") .. " for " .. duration
    elseif commandName == "ungag" then
        return ply:Nick() .. " ungagged " .. (targetName or "unknown")
    else
        -- Generic format for other commands
        return ply:Nick() .. " executed " .. commandName .. " " .. table.concat(args or {}, " ")
    end
end

-- Helper function to notify all admins of an action
function Sovereign.NotifyAdminsAction(message)
    if not SERVER then return end
    
    local actionPrefix = Sovereign.Config.Chat and Sovereign.Config.Chat.AdminActionPrefix or "[Admin Action]"
    
    for _, ply in ipairs(player.GetAll()) do
        -- Check if player has mod or higher role
        if Sovereign.PlayerHasRole(ply, "mod") then
            ply:ChatPrint(actionPrefix .. " " .. message)
        end
    end
end

-- Chat hook to process commands
if SERVER then
    hook.Add("PlayerSay", "Sovereign_CommandProcessor", function(ply, text)
        local prefix = Sovereign.Config.Prefix or "!"
        local silentPrefix = Sovereign.Config.Chat and Sovereign.Config.Chat.SilentCommandPrefix or "$"
        local isSilent = false
        
        -- Check for silent command prefix
        if string.sub(text, 1, #silentPrefix) == silentPrefix then
            -- Check if player has permission for silent commands
            if Sovereign.Config.Chat and Sovereign.Config.Chat.CanUseSilentCommands and next(Sovereign.Config.Chat.CanUseSilentCommands) then
                local hasPermission = false
                for _, role in ipairs(Sovereign.Config.Chat.CanUseSilentCommands) do
                    if Sovereign.PlayerHasRole(ply, role) then
                        hasPermission = true
                        break
                    end
                end
                
                if not hasPermission then
                    Sovereign.NotifyPlayer(ply, "You don't have permission to use silent commands.")
                    return ""
                end
            end
            
            isSilent = true
            -- Remove silent prefix and process as command
            local commandString = string.Trim(string.sub(text, #silentPrefix + 1))
            local args = string.Explode(" ", commandString)
            local commandName = string.lower(table.remove(args, 1) or "")
            
            if commandName == "" then return "" end
            
            -- Execute the command silently
            Sovereign.ExecuteCommand(ply, commandName, args, true)
            
            return "" -- Suppress the message from chat
        end
        
        -- Check for normal command prefix
        if string.sub(text, 1, #prefix) ~= prefix then
            return
        end
        
        -- Remove prefix and split into command and arguments
        local commandString = string.Trim(string.sub(text, #prefix + 1))
        local args = string.Explode(" ", commandString)
        local commandName = string.lower(table.remove(args, 1) or "")
        
        if commandName == "" then return end
        
        -- Execute the command
        Sovereign.ExecuteCommand(ply, commandName, args, false)
        
        return "" -- Suppress the message from chat
    end)
end

print("[Sovereign] Core system loaded.")
