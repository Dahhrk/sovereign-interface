-- sh_limits.lua - Sandbox spawn limits tied to user groups

Sovereign = Sovereign or {}
Sovereign.Config = Sovereign.Config or {}
Sovereign.Config.Limits = Sovereign.Config.Limits or {}

-- Sandbox limits per usergroup
-- These limits apply to props, ragdolls, effects, balloons, etc.
Sovereign.Config.Limits.Groups = {
    ["user"] = {
        props = 50,
        ragdolls = 5,
        vehicles = 2,
        effects = 10,
        balloons = 10,
        emitters = 5,
        npcs = 5,
        sentries = 2,
        thrusters = 10,
        dynamite = 5,
        lamps = 5,
        lights = 5,
        wheels = 4,
        hoverballs = 2,
        buttons = 20,
        cameras = 5
    },
    ["mod"] = {
        props = 100,
        ragdolls = 10,
        vehicles = 4,
        effects = 20,
        balloons = 20,
        emitters = 10,
        npcs = 10,
        sentries = 5,
        thrusters = 20,
        dynamite = 10,
        lamps = 10,
        lights = 10,
        wheels = 8,
        hoverballs = 4,
        buttons = 40,
        cameras = 10
    },
    ["admin"] = {
        props = 200,
        ragdolls = 20,
        vehicles = 8,
        effects = 40,
        balloons = 40,
        emitters = 20,
        npcs = 20,
        sentries = 10,
        thrusters = 40,
        dynamite = 20,
        lamps = 20,
        lights = 20,
        wheels = 16,
        hoverballs = 8,
        buttons = 80,
        cameras = 20
    },
    ["superadmin"] = {
        props = 500,
        ragdolls = 50,
        vehicles = 20,
        effects = 100,
        balloons = 100,
        emitters = 50,
        npcs = 50,
        sentries = 25,
        thrusters = 100,
        dynamite = 50,
        lamps = 50,
        lights = 50,
        wheels = 40,
        hoverballs = 20,
        buttons = 200,
        cameras = 50
    }
}

-- Apply sandbox limits based on usergroup
if SERVER then
    hook.Add("PlayerSpawnProp", "Sovereign_ApplyLimits", function(ply, model)
        local group = ply:GetUserGroup()
        local limits = Sovereign.Config.Limits.Groups[group]
        
        if limits and limits.props then
            if ply:GetCount("props") >= limits.props then
                return false
            end
        end
    end)
    
    hook.Add("PlayerSpawnedProp", "Sovereign_CountProps", function(ply, model, ent)
        local group = ply:GetUserGroup()
        local limits = Sovereign.Config.Limits.Groups[group]
        
        if limits and limits.props then
            ply:AddCount("props", ent)
        end
    end)
end

print("[Sovereign] Sandbox limits configuration loaded.")
