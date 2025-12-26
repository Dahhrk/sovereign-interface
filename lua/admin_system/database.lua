-- admin_system/database.lua
local db = nil

function ConnectDatabase()
    db = mysqloo.connect("hostname", "username", "password", "database", 3306)

    function db:onConnectionFailed(err)
        print("[Sovereign-Database] Connection failed: " .. err)
    end

    function db:onConnected()
        print("[Sovereign-Database] Successfully connected to MySQL.")
    end

    db:connect()
end