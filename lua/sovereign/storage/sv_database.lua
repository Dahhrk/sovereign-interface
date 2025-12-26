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
        
        -- Playtime table
        sql.Query([[
            CREATE TABLE IF NOT EXISTS sovereign_playtime (
                steamid TEXT PRIMARY KEY,
                total_seconds INTEGER DEFAULT 0,
                last_updated INTEGER
            )
        ]])
        
        -- User ranks table
        sql.Query([[
            CREATE TABLE IF NOT EXISTS sovereign_users (
                steamid TEXT PRIMARY KEY,
                rank TEXT,
                last_updated INTEGER
            )
        ]])
        
        -- Jail positions table
        sql.Query([[
            CREATE TABLE IF NOT EXISTS sovereign_jail_positions (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                pos_x REAL,
                pos_y REAL,
                pos_z REAL,
                ang_y REAL
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
        
        -- Playtime table
        local q4 = db:query([[
            CREATE TABLE IF NOT EXISTS sovereign_playtime (
                steamid VARCHAR(32) PRIMARY KEY,
                total_seconds INT DEFAULT 0,
                last_updated INT
            )
        ]])
        q4.onSuccess = function() print("[Sovereign] MySQL playtime table created.") end
        q4.onError = function(_, err) print("[Sovereign] MySQL playtime table error: " .. err) end
        q4:start()
        
        -- User ranks table
        local q5 = db:query([[
            CREATE TABLE IF NOT EXISTS sovereign_users (
                steamid VARCHAR(32) PRIMARY KEY,
                rank VARCHAR(32),
                last_updated INT
            )
        ]])
        q5.onSuccess = function() print("[Sovereign] MySQL users table created.") end
        q5.onError = function(_, err) print("[Sovereign] MySQL users table error: " .. err) end
        q5:start()
        
        -- Jail positions table
        local q6 = db:query([[
            CREATE TABLE IF NOT EXISTS sovereign_jail_positions (
                id INT AUTO_INCREMENT PRIMARY KEY,
                pos_x FLOAT,
                pos_y FLOAT,
                pos_z FLOAT,
                ang_y FLOAT
            )
        ]])
        q6.onSuccess = function() print("[Sovereign] MySQL jail positions table created.") end
        q6.onError = function(_, err) print("[Sovereign] MySQL jail positions table error: " .. err) end
        q6:start()
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

-- Update playtime
function Sovereign.Database.UpdatePlaytime(steamid, sessionSeconds)
    local dbType = Sovereign.Database.Type or "sqlite"
    
    if dbType == "sqlite" then
        -- Get current playtime
        local result = sql.Query(string.format([[
            SELECT total_seconds FROM sovereign_playtime WHERE steamid = %s
        ]], sql.SQLStr(steamid)))
        
        local currentTotal = 0
        if result and #result > 0 then
            currentTotal = tonumber(result[1].total_seconds) or 0
        end
        
        local newTotal = currentTotal + math.floor(sessionSeconds)
        
        -- Update or insert
        local query = sql.Query(string.format([[
            INSERT OR REPLACE INTO sovereign_playtime 
            (steamid, total_seconds, last_updated) 
            VALUES (%s, %d, %d)
        ]], 
            sql.SQLStr(steamid),
            newTotal,
            os.time()
        ))
        
        if query == false then
            print("[Sovereign] Error updating playtime: " .. sql.LastError())
        end
    elseif dbType == "mysql" then
        local db = Sovereign.Database.Connection
        if not db then return end
        
        local newTotal = math.floor(sessionSeconds)
        local q = db:query(string.format([[
            INSERT INTO sovereign_playtime (steamid, total_seconds, last_updated) 
            VALUES ('%s', %d, %d) 
            ON DUPLICATE KEY UPDATE 
            total_seconds = total_seconds + %d, 
            last_updated = %d
        ]], db:escape(steamid), newTotal, os.time(), newTotal, os.time()))
        q.onError = function(_, err) print("[Sovereign] MySQL playtime update error: " .. err) end
        q:start()
    end
end

-- Get playtime
function Sovereign.Database.GetPlaytime(steamid, callback)
    local dbType = Sovereign.Database.Type or "sqlite"
    
    if dbType == "sqlite" then
        local result = sql.Query(string.format([[
            SELECT total_seconds FROM sovereign_playtime WHERE steamid = %s
        ]], sql.SQLStr(steamid)))
        
        if result and #result > 0 then
            callback(tonumber(result[1].total_seconds) or 0)
        else
            callback(0)
        end
    elseif dbType == "mysql" then
        local db = Sovereign.Database.Connection
        if not db then 
            callback(0)
            return 
        end
        
        local q = db:query(string.format([[
            SELECT total_seconds FROM sovereign_playtime WHERE steamid = '%s'
        ]], db:escape(steamid)))
        q.onSuccess = function(_, data)
            if data and #data > 0 then
                callback(tonumber(data[1].total_seconds) or 0)
            else
                callback(0)
            end
        end
        q.onError = function(_, err) 
            print("[Sovereign] MySQL playtime get error: " .. err)
            callback(0)
        end
        q:start()
    end
end

-- Set user rank
function Sovereign.Database.SetUserRank(steamid, rank)
    local dbType = Sovereign.Database.Type or "sqlite"
    
    if dbType == "sqlite" then
        local query = sql.Query(string.format([[
            INSERT OR REPLACE INTO sovereign_users 
            (steamid, rank, last_updated) 
            VALUES (%s, %s, %d)
        ]], 
            sql.SQLStr(steamid),
            sql.SQLStr(rank),
            os.time()
        ))
        
        if query == false then
            print("[Sovereign] Error setting user rank: " .. sql.LastError())
        end
    elseif dbType == "mysql" then
        local db = Sovereign.Database.Connection
        if not db then return end
        
        local q = db:query(string.format([[
            INSERT INTO sovereign_users (steamid, rank, last_updated) 
            VALUES ('%s', '%s', %d) 
            ON DUPLICATE KEY UPDATE 
            rank = '%s', 
            last_updated = %d
        ]], db:escape(steamid), db:escape(rank), os.time(), db:escape(rank), os.time()))
        q.onError = function(_, err) print("[Sovereign] MySQL rank update error: " .. err) end
        q:start()
    end
end

-- Remove user
function Sovereign.Database.RemoveUser(steamid)
    local dbType = Sovereign.Database.Type or "sqlite"
    
    if dbType == "sqlite" then
        -- Remove from users table
        sql.Query(string.format([[
            DELETE FROM sovereign_users WHERE steamid = %s
        ]], sql.SQLStr(steamid)))
        
        -- Remove warnings
        sql.Query(string.format([[
            DELETE FROM sovereign_warnings WHERE steamid = %s
        ]], sql.SQLStr(steamid)))
        
        -- Note: We don't remove bans or logs for record keeping
    elseif dbType == "mysql" then
        local db = Sovereign.Database.Connection
        if not db then return end
        
        -- Remove from users table
        local q1 = db:query(string.format([[
            DELETE FROM sovereign_users WHERE steamid = '%s'
        ]], db:escape(steamid)))
        q1.onError = function(_, err) print("[Sovereign] MySQL remove user error: " .. err) end
        q1:start()
        
        -- Remove warnings
        local q2 = db:query(string.format([[
            DELETE FROM sovereign_warnings WHERE steamid = '%s'
        ]], db:escape(steamid)))
        q2.onError = function(_, err) print("[Sovereign] MySQL remove warnings error: " .. err) end
        q2:start()
    end
end

-- Set jail positions
function Sovereign.Database.SetJailPositions(positions)
    local dbType = Sovereign.Database.Type or "sqlite"
    
    if dbType == "sqlite" then
        -- Clear existing positions
        sql.Query("DELETE FROM sovereign_jail_positions")
        
        -- Insert new positions
        for _, pos in ipairs(positions) do
            local query = sql.Query(string.format([[
                INSERT INTO sovereign_jail_positions 
                (pos_x, pos_y, pos_z, ang_y) 
                VALUES (%f, %f, %f, %f)
            ]], 
                pos.pos.x,
                pos.pos.y,
                pos.pos.z,
                pos.ang.y
            ))
            
            if query == false then
                print("[Sovereign] Error setting jail position: " .. sql.LastError())
            end
        end
    elseif dbType == "mysql" then
        local db = Sovereign.Database.Connection
        if not db then return end
        
        -- Clear existing positions
        local qClear = db:query("DELETE FROM sovereign_jail_positions")
        qClear.onSuccess = function()
            -- Insert new positions
            for _, pos in ipairs(positions) do
                local qInsert = db:query(string.format([[
                    INSERT INTO sovereign_jail_positions 
                    (pos_x, pos_y, pos_z, ang_y) 
                    VALUES (%f, %f, %f, %f)
                ]], pos.pos.x, pos.pos.y, pos.pos.z, pos.ang.y))
                qInsert.onError = function(_, err) print("[Sovereign] MySQL jail position insert error: " .. err) end
                qInsert:start()
            end
        end
        qClear.onError = function(_, err) print("[Sovereign] MySQL jail position clear error: " .. err) end
        qClear:start()
    end
end

-- Get jail positions
function Sovereign.Database.GetJailPositions()
    local dbType = Sovereign.Database.Type or "sqlite"
    local positions = {}
    
    if dbType == "sqlite" then
        local result = sql.Query("SELECT * FROM sovereign_jail_positions")
        
        if result then
            for _, row in ipairs(result) do
                table.insert(positions, {
                    pos = Vector(tonumber(row.pos_x), tonumber(row.pos_y), tonumber(row.pos_z)),
                    ang = Angle(0, tonumber(row.ang_y), 0)
                })
            end
        end
    elseif dbType == "mysql" then
        -- For MySQL, we need to load positions asynchronously on server start
        -- This function returns empty table for MySQL, positions are loaded via hook
        local db = Sovereign.Database.Connection
        if not db then return positions end
        
        local q = db:query("SELECT * FROM sovereign_jail_positions")
        q.onSuccess = function(_, data)
            if data then
                for _, row in ipairs(data) do
                    table.insert(Sovereign.JailPositions, {
                        pos = Vector(tonumber(row.pos_x), tonumber(row.pos_y), tonumber(row.pos_z)),
                        ang = Angle(0, tonumber(row.ang_y), 0)
                    })
                end
            end
        end
        q.onError = function(_, err) print("[Sovereign] MySQL jail position load error: " .. err) end
        q:start()
    end
    
    return positions
end

-- Load jail positions on startup
hook.Add("Initialize", "Sovereign_LoadJailPositions", function()
    timer.Simple(1, function()
        if Sovereign.Database and Sovereign.Database.GetJailPositions then
            Sovereign.JailPositions = Sovereign.Database.GetJailPositions()
            if #Sovereign.JailPositions > 0 then
                print("[Sovereign] Loaded " .. #Sovereign.JailPositions .. " jail positions from database")
            end
        end
    end)
end)

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
