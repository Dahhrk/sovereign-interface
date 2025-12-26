-- sv_database.lua - Generic database handling for Sovereign Admin System

if not SERVER then return end

Sovereign = Sovereign or {}
Sovereign.Database = Sovereign.Database or {}

-- Initialize database connection
function Sovereign.Database.Initialize()
    -- Determine database type at initialization time when config is available
    local dbType = Sovereign.Config and Sovereign.Config.Database and Sovereign.Config.Database.Type or "sqlite"
    Sovereign.Database.Type = dbType
    
    if dbType == "mysql" then
        Sovereign.Database.InitMySQL()
    else
        Sovereign.Database.InitSQLite()
    end
end

-- MySQL initialization
function Sovereign.Database.InitMySQL()
    if not mysqloo then
        print("[Sovereign] MySQLOO module not found! Falling back to SQLite.")
        Sovereign.Database.Type = "sqlite"
        Sovereign.Database.InitSQLite()
        return
    end
    
    local config = Sovereign.Config.Database.MySQL
    local db = mysqloo.connect(config.Host, config.Username, config.Password, config.Database, config.Port)
    
    function db:onConnected()
        print("[Sovereign] MySQL database connected!")
        Sovereign.Database.CreateTables()
    end
    
    function db:onConnectionFailed(err)
        print("[Sovereign] MySQL connection failed: " .. err)
        print("[Sovereign] Falling back to SQLite.")
        Sovereign.Database.Type = "sqlite"
        Sovereign.Database.InitSQLite()
    end
    
    db:connect()
    Sovereign.Database.Connection = db
end

-- SQLite initialization
function Sovereign.Database.InitSQLite()
    if not sql then
        print("[Sovereign] SQL module not available!")
        return
    end
    
    print("[Sovereign] Using SQLite database.")
    Sovereign.Database.CreateTables()
end

-- Create database tables
function Sovereign.Database.CreateTables()
    local dbType = Sovereign.Database.Type or "sqlite"
    
    if dbType == "sqlite" then
        -- Bans table
        sql.Query([[
            CREATE TABLE IF NOT EXISTS sovereign_bans (
                steamid TEXT PRIMARY KEY,
                name TEXT,
                admin_steamid TEXT,
                admin_name TEXT,
                duration INTEGER,
                reason TEXT,
                timestamp INTEGER
            )
        ]])
        
        -- Warnings table
        sql.Query([[
            CREATE TABLE IF NOT EXISTS sovereign_warnings (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                steamid TEXT,
                name TEXT,
                admin_steamid TEXT,
                admin_name TEXT,
                reason TEXT,
                timestamp INTEGER
            )
        ]])
        
        -- Command logs table
        sql.Query([[
            CREATE TABLE IF NOT EXISTS sovereign_logs (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                steamid TEXT,
                command TEXT,
                arguments TEXT,
                timestamp INTEGER
            )
        ]])
        
        print("[Sovereign] SQLite tables created successfully.")
    elseif dbType == "mysql" then
        -- MySQL table creation
        local db = Sovereign.Database.Connection
        if not db then
            print("[Sovereign] MySQL connection not available for table creation!")
            return
        end
        
        -- Bans table
        local q = db:query([[
            CREATE TABLE IF NOT EXISTS sovereign_bans (
                steamid VARCHAR(32) PRIMARY KEY,
                name VARCHAR(255),
                admin_steamid VARCHAR(32),
                admin_name VARCHAR(255),
                duration INT,
                reason TEXT,
                timestamp INT
            )
        ]])
        q.onSuccess = function() print("[Sovereign] MySQL bans table created.") end
        q.onError = function(_, err) print("[Sovereign] MySQL bans table error: " .. err) end
        q:start()
        
        -- Warnings table
        local q2 = db:query([[
            CREATE TABLE IF NOT EXISTS sovereign_warnings (
                id INT AUTO_INCREMENT PRIMARY KEY,
                steamid VARCHAR(32),
                name VARCHAR(255),
                admin_steamid VARCHAR(32),
                admin_name VARCHAR(255),
                reason TEXT,
                timestamp INT
            )
        ]])
        q2.onSuccess = function() print("[Sovereign] MySQL warnings table created.") end
        q2.onError = function(_, err) print("[Sovereign] MySQL warnings table error: " .. err) end
        q2:start()
        
        -- Logs table
        local q3 = db:query([[
            CREATE TABLE IF NOT EXISTS sovereign_logs (
                id INT AUTO_INCREMENT PRIMARY KEY,
                steamid VARCHAR(32),
                command VARCHAR(255),
                arguments TEXT,
                timestamp INT
            )
        ]])
        q3.onSuccess = function() print("[Sovereign] MySQL logs table created.") end
        q3.onError = function(_, err) print("[Sovereign] MySQL logs table error: " .. err) end
        q3:start()
    end
end

-- Add a ban
function Sovereign.Database.AddBan(steamid, name, adminSteamid, adminName, duration, reason)
    local dbType = Sovereign.Database.Type or "sqlite"
    
    if dbType == "sqlite" then
        local query = sql.Query(string.format([[
            INSERT OR REPLACE INTO sovereign_bans 
            (steamid, name, admin_steamid, admin_name, duration, reason, timestamp) 
            VALUES (%s, %s, %s, %s, %d, %s, %d)
        ]], 
            sql.SQLStr(steamid),
            sql.SQLStr(name),
            sql.SQLStr(adminSteamid),
            sql.SQLStr(adminName),
            duration,
            sql.SQLStr(reason),
            os.time()
        ))
        
        if query == false then
            print("[Sovereign] Error adding ban: " .. sql.LastError())
        end
    end
end

-- Remove a ban
function Sovereign.Database.RemoveBan(steamid)
    local dbType = Sovereign.Database.Type or "sqlite"
    
    if dbType == "sqlite" then
        local query = sql.Query(string.format([[
            DELETE FROM sovereign_bans WHERE steamid = %s
        ]], sql.SQLStr(steamid)))
        
        if query == false then
            print("[Sovereign] Error removing ban: " .. sql.LastError())
        end
    end
end

-- Check if player is banned
function Sovereign.Database.IsBanned(steamid)
    local dbType = Sovereign.Database.Type or "sqlite"
    
    if dbType == "sqlite" then
        local result = sql.Query(string.format([[
            SELECT * FROM sovereign_bans WHERE steamid = %s
        ]], sql.SQLStr(steamid)))
        
        if result and #result > 0 then
            local ban = result[1]
            local banTime = tonumber(ban.timestamp)
            local duration = tonumber(ban.duration)
            
            -- Check if ban is permanent or still active
            if duration == 0 then
                return true, ban.reason
            elseif os.time() - banTime < (duration * 60) then
                return true, ban.reason
            else
                -- Ban expired, remove it
                Sovereign.Database.RemoveBan(steamid)
                return false
            end
        end
    end
    
    return false
end

-- Add a warning
function Sovereign.Database.AddWarning(steamid, name, adminSteamid, adminName, reason)
    local dbType = Sovereign.Database.Type or "sqlite"
    
    if dbType == "sqlite" then
        local query = sql.Query(string.format([[
            INSERT INTO sovereign_warnings 
            (steamid, name, admin_steamid, admin_name, reason, timestamp) 
            VALUES (%s, %s, %s, %s, %s, %d)
        ]], 
            sql.SQLStr(steamid),
            sql.SQLStr(name),
            sql.SQLStr(adminSteamid),
            sql.SQLStr(adminName),
            sql.SQLStr(reason),
            os.time()
        ))
        
        if query == false then
            print("[Sovereign] Error adding warning: " .. sql.LastError())
        end
    end
end

-- Log a command
function Sovereign.Database.LogAction(steamid, command, arguments)
    if not Sovereign.Config.EnableLogging then return end
    
    local dbType = Sovereign.Database.Type or "sqlite"
    
    if dbType == "sqlite" then
        local query = sql.Query(string.format([[
            INSERT INTO sovereign_logs 
            (steamid, command, arguments, timestamp) 
            VALUES (%s, %s, %s, %d)
        ]], 
            sql.SQLStr(steamid),
            sql.SQLStr(command),
            sql.SQLStr(arguments),
            os.time()
        ))
        
        if query == false then
            print("[Sovereign] Error logging action: " .. sql.LastError())
        end
    end
end

-- Check bans on player connect
hook.Add("CheckPassword", "Sovereign_BanCheck", function(steamid64, ipaddress, svpassword, clpassword, name)
    local steamid = util.SteamIDFrom64(steamid64)
    local isBanned, reason = Sovereign.Database.IsBanned(steamid)
    
    if isBanned then
        return false, "You are banned from this server. Reason: " .. (reason or "No reason given")
    end
end)

-- Initialize database on server start
timer.Simple(0, function()
    Sovereign.Database.Initialize()
end)

print("[Sovereign] Database system loaded.")
