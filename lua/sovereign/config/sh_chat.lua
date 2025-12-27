-- sh_chat.lua - Chat configuration for Sovereign Admin System

Sovereign = Sovereign or {}
Sovereign.Config = Sovereign.Config or {}
Sovereign.Config.Chat = Sovereign.Config.Chat or {}

-- Prefix for typing in Admin Chat (e.g., @ or .a)
Sovereign.Config.Chat.AdminChatPrefix = "@"

-- Prefix for admin logs visible to staff
Sovereign.Config.Chat.AdminActionPrefix = "[Admin Action]"

-- Prefix for silent command execution (e.g., $)
Sovereign.Config.Chat.SilentCommandPrefix = "$"

-- Configurable colors for admin messages
Sovereign.Config.Chat.Colors = {
    AdminChat = Color(255, 200, 0),      -- Bright orange
    AdminAction = Color(0, 200, 255),    -- Bright cyan
    SilentCommand = Color(100, 100, 100) -- Gray (only visible to issuer)
}

-- Log all admin actions for visibility (toggleable)
Sovereign.Config.Chat.AdminLogsVisibleToStaff = true

-- Roles allowed to run commands silently
Sovereign.Config.Chat.CanUseSilentCommands = {
    "superadmin",
    "admin"
}

print("[Sovereign] Chat configuration loaded.")
