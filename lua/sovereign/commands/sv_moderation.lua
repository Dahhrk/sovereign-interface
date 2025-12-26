-- Ban Command
RegisterCommand("ban", { "superadmin", "admin" }, function(admin, args)
    local target = GetPlayerByName(args[1])
    local duration = tonumber(args[2]) or 0
    local reason = args[3] or "No reason given"
    if not target then return NotifyAdmin(admin, "Player not found") end
    target:Kick("Banned for: " .. reason)
    NotifyAdmins(admin:Nick() .. " banned " .. target:Nick() .. " for " .. duration .. " minutes. Reason: " .. reason)
end)