function ConnectToDatabase()
    local db = mysqloo.connect("hostname", "username", "password", "database", 3306)

    function db:onConnected() print("[Sovereign] Database connected!") end
    function db:onConnectionFailed(err) print("[Sovereign] Connection failed: " .. err) end
    db:connect()
end