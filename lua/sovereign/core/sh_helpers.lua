-- sh_helpers.lua - Helper utilities for Sovereign Admin System

Sovereign = Sovereign or {}
Sovereign.Helpers = Sovereign.Helpers or {}

-- Format time duration to human readable string
function Sovereign.Helpers.FormatTime(seconds)
    if seconds == 0 then return "Permanent" end
    
    local days = math.floor(seconds / 86400)
    local hours = math.floor((seconds % 86400) / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local secs = seconds % 60
    
    local parts = {}
    
    if days > 0 then
        table.insert(parts, days .. "d")
    end
    if hours > 0 then
        table.insert(parts, hours .. "h")
    end
    if minutes > 0 then
        table.insert(parts, minutes .. "m")
    end
    if secs > 0 and days == 0 then
        table.insert(parts, secs .. "s")
    end
    
    return table.concat(parts, " ")
end

-- Parse time string to seconds (e.g., "1h30m", "2d", "30m")
function Sovereign.Helpers.ParseTime(timeStr)
    if not timeStr then return 0 end
    
    local total = 0
    
    -- Match days
    local days = string.match(timeStr, "(%d+)d")
    if days then total = total + (tonumber(days) * 86400) end
    
    -- Match hours
    local hours = string.match(timeStr, "(%d+)h")
    if hours then total = total + (tonumber(hours) * 3600) end
    
    -- Match minutes
    local minutes = string.match(timeStr, "(%d+)m")
    if minutes then total = total + (tonumber(minutes) * 60) end
    
    -- Match seconds
    local seconds = string.match(timeStr, "(%d+)s")
    if seconds then total = total + tonumber(seconds) end
    
    -- If no unit specified, assume minutes
    if total == 0 then
        local num = tonumber(timeStr)
        if num then total = num * 60 end
    end
    
    return total
end

-- Sanitize player name for display/storage
function Sovereign.Helpers.SanitizeName(name)
    if not name then return "Unknown" end
    return string.gsub(name, "[^%w%s%-_]", "")
end

-- Check if string is a valid SteamID
function Sovereign.Helpers.IsValidSteamID(steamid)
    if not steamid then return false end
    return string.match(steamid, "STEAM_%d:%d:%d+") ~= nil
end

-- Get player count by usergroup
function Sovereign.Helpers.GetUserGroupCount(usergroup)
    local count = 0
    for _, ply in ipairs(player.GetAll()) do
        if ply:GetUserGroup() == usergroup then
            count = count + 1
        end
    end
    return count
end

-- Get all players with a specific usergroup
function Sovereign.Helpers.GetPlayersByUserGroup(usergroup)
    local players = {}
    for _, ply in ipairs(player.GetAll()) do
        if ply:GetUserGroup() == usergroup then
            table.insert(players, ply)
        end
    end
    return players
end

-- Table contains value
function Sovereign.Helpers.TableContains(tbl, value)
    for _, v in pairs(tbl) do
        if v == value then
            return true
        end
    end
    return false
end

-- Deep copy a table
function Sovereign.Helpers.TableCopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[Sovereign.Helpers.TableCopy(orig_key)] = Sovereign.Helpers.TableCopy(orig_value)
        end
        setmetatable(copy, Sovereign.Helpers.TableCopy(getmetatable(orig)))
    else
        copy = orig
    end
    return copy
end

-- Format SteamID64 to SteamID
function Sovereign.Helpers.SteamID64ToSteamID(steamid64)
    if not steamid64 then return nil end
    return util.SteamIDFrom64(steamid64)
end

-- Format SteamID to SteamID64
function Sovereign.Helpers.SteamIDToSteamID64(steamid)
    if not steamid then return nil end
    return util.SteamIDTo64(steamid)
end

print("[Sovereign] Helper utilities loaded.")
