-- autorun/sovereign_loader.lua

if SERVER then
    include("sovereign/sh_init.lua") -- Entry point for the Sovereign Admin System
    print("[Sovereign] Admin system initialized (Server-side).")
else
    print("[Sovereign] Admin system initialized (Client-side).")
end