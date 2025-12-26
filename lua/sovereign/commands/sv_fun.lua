-- Freeze Command
RegisterCommand("freeze", { "admin", "mod" }, function(admin, args)
    local target = GetPlayerByName(args[1])
    if not target then return NotifyAdmin(admin, "Player not found.") end
    target:Freeze(true)
    NotifyAdmin(admin, "You froze " .. target:Nick())
end)

-- Slay Command
RegisterCommand("slay", { "admin" }, function(admin, args)
    local target = GetPlayerByName(args[1])
    if not target then return NotifyAdmin(admin, "Player not found.") end
    target:Kill()
    NotifyAdmin(admin, "You slayed " .. target:Nick())
end)