-- cl_theme_base.lua - Base theme for future Sovereign UI

if not CLIENT then return end

Sovereign = Sovereign or {}
Sovereign.Theme = Sovereign.Theme or {}

-- Color Scheme
Sovereign.Theme.Colors = {
    Primary = Color(41, 128, 185),      -- Blue
    Secondary = Color(52, 73, 94),      -- Dark Blue-Gray
    Success = Color(39, 174, 96),       -- Green
    Warning = Color(243, 156, 18),      -- Orange
    Danger = Color(231, 76, 60),        -- Red
    
    Background = Color(30, 30, 30),     -- Dark Background
    BackgroundLight = Color(45, 45, 45), -- Lighter Background
    
    Text = Color(236, 240, 241),        -- Light Text
    TextDark = Color(127, 140, 141),    -- Darker Text
    
    Border = Color(52, 73, 94),         -- Border Color
}

-- Font Sizes
Sovereign.Theme.Fonts = {
    Small = "SovereignSmall",
    Normal = "SovereignNormal",
    Large = "SovereignLarge",
    Title = "SovereignTitle"
}

-- Spacing
Sovereign.Theme.Spacing = {
    Small = 4,
    Medium = 8,
    Large = 16,
    XLarge = 24
}

-- Create fonts when UI is implemented
--[[
surface.CreateFont(Sovereign.Theme.Fonts.Small, {
    font = "Roboto",
    size = 14,
    weight = 400
})

surface.CreateFont(Sovereign.Theme.Fonts.Normal, {
    font = "Roboto",
    size = 16,
    weight = 400
})

surface.CreateFont(Sovereign.Theme.Fonts.Large, {
    font = "Roboto",
    size = 20,
    weight = 500
})

surface.CreateFont(Sovereign.Theme.Fonts.Title, {
    font = "Roboto",
    size = 24,
    weight = 700
})
]]

print("[Sovereign] Theme system loaded.")
