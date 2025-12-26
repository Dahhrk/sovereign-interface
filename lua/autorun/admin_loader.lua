-- autorun/admin_loader.lua
if SERVER then
    include("admin_system/init.lua") -- Load the main admin system entry point
    print("[Sovereign-Interface] Admin system initialized.")
end