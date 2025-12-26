-- sh_localization.lua - Multi-language support for Sovereign Admin System

Sovereign = Sovereign or {}
Sovereign.Config = Sovereign.Config or {}
Sovereign.Config.Language = Sovereign.Config.Language or {}

-- Current language (default: english)
Sovereign.Config.Language.Current = "english"

-- Language strings
Sovereign.Config.Language.Strings = {
    ["english"] = {
        -- General messages
        ["command_not_found"] = "Command not found: %s",
        ["no_permission"] = "You don't have permission to use this command.",
        ["player_not_found"] = "Player not found: %s",
        ["usage"] = "Usage: %s",
        
        -- Admin mode messages
        ["adminmode_enabled"] = "Admin mode enabled.",
        ["adminmode_disabled"] = "Admin mode disabled.",
        ["adminmode_not_available"] = "Admin mode is not available.",
        
        -- Role management messages
        ["role_added"] = "Role '%s' added to %s",
        ["role_removed"] = "Role '%s' removed from %s",
        ["role_not_found"] = "Role not found: %s",
        ["role_already_exists"] = "Player already has this role.",
        
        -- Command feedback
        ["freeze_success"] = "You froze %s",
        ["unfreeze_success"] = "You unfroze %s",
        ["teleport_success"] = "Teleported to %s",
        ["ban_success"] = "Banned %s for %s minutes",
        
        -- Common
        ["success"] = "Success!",
        ["error"] = "Error: %s",
    }
}

-- Placeholder for additional languages (Spanish example)
Sovereign.Config.Language.Strings["spanish"] = {
    ["command_not_found"] = "Comando no encontrado: %s",
    ["no_permission"] = "No tienes permiso para usar este comando.",
    ["player_not_found"] = "Jugador no encontrado: %s",
    ["usage"] = "Uso: %s",
    -- Add more translations as needed
}

-- Function to get localized string
function Sovereign.GetString(key, ...)
    local lang = Sovereign.Config.Language.Current
    local strings = Sovereign.Config.Language.Strings[lang]
    
    if not strings or not strings[key] then
        -- Fallback to english
        strings = Sovereign.Config.Language.Strings["english"]
    end
    
    local str = strings[key] or key
    
    -- Format string with arguments if provided
    if ... then
        return string.format(str, ...)
    end
    
    return str
end

print("[Sovereign] Localization support loaded. Current language: " .. Sovereign.Config.Language.Current)
