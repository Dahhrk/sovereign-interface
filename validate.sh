#!/bin/bash
# Sovereign Admin System - Validation Script
# This script validates the installation and structure of the Sovereign Admin System

echo "==================================="
echo "Sovereign Admin System Validation"
echo "==================================="
echo ""

ERRORS=0
WARNINGS=0

# Check folder structure
echo "1. Checking folder structure..."
FOLDERS=(
    "lua/autorun"
    "lua/sovereign"
    "lua/sovereign/config"
    "lua/sovereign/core"
    "lua/sovereign/commands"
    "lua/sovereign/storage"
    "lua/sovereign/ui"
    "lua/sovereign/ui/themes"
)

for folder in "${FOLDERS[@]}"; do
    if [ -d "$folder" ]; then
        echo "  ✓ $folder exists"
    else
        echo "  ✗ $folder missing"
        ((ERRORS++))
    fi
done

echo ""

# Check required config files
echo "2. Checking config files..."
CONFIG_FILES=(
    "lua/sovereign/config/sh_config.lua"
    "lua/sovereign/config/sh_adminmode.lua"
    "lua/sovereign/config/sh_limits.lua"
    "lua/sovereign/config/sh_localization.lua"
    "lua/sovereign/config/sh_roles.lua"
)

for file in "${CONFIG_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "  ✓ $file exists"
    else
        echo "  ✗ $file missing"
        ((ERRORS++))
    fi
done

echo ""

# Check core files
echo "3. Checking core files..."
CORE_FILES=(
    "lua/sovereign/core/sh_core.lua"
    "lua/sovereign/core/sh_helpers.lua"
    "lua/sovereign/core/sh_compat.lua"
)

for file in "${CORE_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "  ✓ $file exists"
    else
        echo "  ✗ $file missing"
        ((ERRORS++))
    fi
done

echo ""

# Check command files
echo "4. Checking command files..."
COMMAND_FILES=(
    "lua/sovereign/commands/sv_admin.lua"
    "lua/sovereign/commands/sv_fun.lua"
    "lua/sovereign/commands/sv_moderation.lua"
    "lua/sovereign/commands/sv_teleport.lua"
    "lua/sovereign/commands/sv_utility.lua"
    "lua/sovereign/commands/sv_chat.lua"
    "lua/sovereign/commands/sv_darkrp.lua"
)

for file in "${COMMAND_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "  ✓ $file exists"
    else
        echo "  ✗ $file missing"
        ((ERRORS++))
    fi
done

echo ""

# Check other essential files
echo "5. Checking other essential files..."
ESSENTIAL_FILES=(
    "lua/autorun/sovereign_loader.lua"
    "lua/sovereign/sh_init.lua"
    "lua/sovereign/storage/sv_database.lua"
)

for file in "${ESSENTIAL_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "  ✓ $file exists"
    else
        echo "  ✗ $file missing"
        ((ERRORS++))
    fi
done

echo ""

# Check Lua syntax
echo "6. Checking Lua syntax..."
LUA_FILES=$(find lua -name "*.lua")
SYNTAX_ERRORS=0

for file in $LUA_FILES; do
    if luac -p "$file" 2>/dev/null; then
        : # No output for successful checks
    else
        echo "  ✗ Syntax error in $file"
        ((SYNTAX_ERRORS++))
        ((ERRORS++))
    fi
done

if [ $SYNTAX_ERRORS -eq 0 ]; then
    echo "  ✓ All Lua files have valid syntax"
else
    echo "  ✗ $SYNTAX_ERRORS files have syntax errors"
fi

echo ""

# Check for key features in files
echo "7. Checking for key features..."

# Check admin mode system
if grep -q "Sovereign.EnableAdminMode" lua/sovereign/commands/sv_admin.lua; then
    echo "  ✓ Admin mode system implemented"
else
    echo "  ⚠ Admin mode system may not be fully implemented"
    ((WARNINGS++))
fi

# Check multi-role system
if grep -q "Sovereign.AddPlayerRole" lua/sovereign/config/sh_roles.lua; then
    echo "  ✓ Multi-role system implemented"
else
    echo "  ⚠ Multi-role system may not be fully implemented"
    ((WARNINGS++))
fi

# Check compatibility layer
if grep -q "CAMI" lua/sovereign/core/sh_compat.lua; then
    echo "  ✓ CAMI compatibility implemented"
else
    echo "  ⚠ CAMI compatibility may not be implemented"
    ((WARNINGS++))
fi

# Check database role storage
if grep -q "SavePlayerRole" lua/sovereign/storage/sv_database.lua; then
    echo "  ✓ Role database storage implemented"
else
    echo "  ⚠ Role database storage may not be implemented"
    ((WARNINGS++))
fi

echo ""

# Count registered commands
echo "8. Counting registered commands..."
COMMAND_COUNT=$(grep -rh "Sovereign.RegisterCommand" lua/sovereign/commands/ | wc -l)
echo "  ℹ Total commands registered: $COMMAND_COUNT"

if [ $COMMAND_COUNT -lt 55 ]; then
    echo "  ⚠ Expected at least 55 commands, found $COMMAND_COUNT"
    ((WARNINGS++))
else
    echo "  ✓ Command count meets requirements"
fi

echo ""

# Check documentation
echo "9. Checking documentation..."
DOC_FILES=(
    "README.md"
    "CONFIGURATION.md"
    "COMMANDS.md"
)

for file in "${DOC_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "  ✓ $file exists"
    else
        echo "  ✗ $file missing"
        ((ERRORS++))
    fi
done

echo ""

# Summary
echo "==================================="
echo "Validation Summary"
echo "==================================="
echo "Errors: $ERRORS"
echo "Warnings: $WARNINGS"
echo ""

if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo "✓ All checks passed! The Sovereign Admin System is properly installed."
    exit 0
elif [ $ERRORS -eq 0 ]; then
    echo "⚠ Validation completed with warnings. The system should work but may have minor issues."
    exit 0
else
    echo "✗ Validation failed with $ERRORS errors. Please fix the issues before using the system."
    exit 1
fi
