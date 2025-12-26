# Security Analysis - Sovereign Admin System

## Overview

This document provides a security analysis of the Sovereign Admin System implementation.

## Security Features Implemented

### 1. Input Validation

**SQL Injection Prevention:**
- All database queries use `sql.SQLStr()` for proper string escaping
- No raw user input is directly concatenated into SQL queries
- Example from `sv_database.lua`:
```lua
sql.Query(string.format([[
    INSERT OR REPLACE INTO sovereign_bans 
    (steamid, name, admin_steamid, admin_name, duration, reason, timestamp) 
    VALUES (%s, %s, %s, %s, %d, %s, %d)
]], 
    sql.SQLStr(steamid),      -- Sanitized
    sql.SQLStr(name),          -- Sanitized
    sql.SQLStr(adminSteamid),  -- Sanitized
    sql.SQLStr(adminName),     -- Sanitized
    duration,                  -- Numeric
    sql.SQLStr(reason),        -- Sanitized
    os.time()                  -- Numeric
))
```

**Command Argument Validation:**
- All commands validate required arguments before execution
- Player lookups validate existence before operations
- Numeric arguments validated with `tonumber()`

### 2. Permission System

**Role-Based Access Control:**
- Commands restricted by role with inheritance
- Permission checks before command execution
- No hardcoded admin checks (uses role system consistently)

**Example:**
```lua
function Sovereign.HasPermission(ply, commandName)
    if not IsValid(ply) then return false end
    
    local cmd = Sovereign.Commands[commandName]
    if not cmd then return false end
    
    local usergroup = ply:GetUserGroup()
    
    for _, role in ipairs(cmd.roles) do
        if Sovereign.CheckRole(usergroup, role) then
            return true
        end
    end
    
    return false
end
```

### 3. Action Logging

**Audit Trail:**
- All command executions logged to database
- Includes: executor, command, arguments, timestamp
- Enables tracking of admin abuse
- Configurable (can be disabled if needed)

### 4. Ban System

**Secure Ban Management:**
- Bans checked on player connection (CheckPassword hook)
- Time-based ban expiration
- Permanent ban support (duration = 0)
- Ban reason storage for reference

### 5. Error Handling

**Graceful Failure:**
- pcall() wrapper around command callbacks prevents crashes
- Database errors logged but don't crash server
- Missing modules (MySQLOO) fallback to SQLite
- Invalid player names return error messages

## Potential Security Considerations

### 1. Database Access

**Current State:**
- SQLite database stored in `data/` folder
- File permissions inherited from server

**Recommendations:**
- Ensure `data/` folder has restrictive permissions (server user only)
- For MySQL, use strong passwords and limited privileges
- Consider encrypting sensitive data at rest

### 2. Command Execution

**Current State:**
- Commands executed via chat hook
- Permission checks before execution
- No arbitrary code execution

**Recommendations:**
- Monitor for command spam (cooldown implemented)
- Consider rate limiting per player
- Log failed permission attempts

### 3. Player Data

**Current State:**
- Stores SteamID, player names, admin actions
- No passwords or sensitive user data

**Recommendations:**
- Comply with data retention policies
- Provide admin tools to purge old data
- Document what data is stored (GDPR compliance)

### 4. Network Communication

**Current State:**
- Server-side only system
- Client receives themed UI files (placeholder)
- No sensitive data sent to clients

**Recommendations:**
- Keep sensitive operations server-side only
- Validate any future client inputs
- Use net messages for future UI (don't trust client)

### 5. Privilege Escalation

**Current State:**
- Roles managed by GMod's usergroup system
- No internal privilege escalation
- Commands can't grant admin rights

**Recommendations:**
- Don't create commands that modify usergroups
- Rely on external systems (ULX, etc.) for role management
- Regular audits of admin list

## Security Best Practices Followed

1. **Principle of Least Privilege:** Commands require minimum necessary permissions
2. **Defense in Depth:** Multiple validation layers (argument checks, permission checks, player validity)
3. **Secure Defaults:** SQLite by default (no external dependencies), logging enabled
4. **Error Handling:** Graceful degradation on errors
5. **Audit Logging:** All actions tracked with timestamps
6. **Input Validation:** All user inputs sanitized before database operations

## Security Testing Performed

### SQL Injection Tests
Tested with:
- `!ban player'); DROP TABLE sovereign_bans; --`
- `!warn player' OR '1'='1`

Result: Queries properly escaped, no injection possible

### Permission Bypass Tests
Tested:
- Non-admin attempting admin commands
- Direct function calls bypassing chat hook

Result: Permission checks enforced in all code paths

### XSS Prevention
- No HTML output (chat only)
- No web interface (yet)

Result: Not applicable for current implementation

## Vulnerability Summary

**High Priority:** None identified

**Medium Priority:** None identified

**Low Priority:**
1. Database file permissions depend on server configuration
2. No built-in rate limiting (relies on cooldown)
3. Future UI implementation needs security review

## Recommendations for Production

1. **Database Security:**
   - Set restrictive file permissions on `data/` folder
   - Use MySQL with dedicated user and strong password
   - Regular database backups

2. **Monitoring:**
   - Review command logs regularly
   - Monitor for unusual admin activity
   - Set up alerts for mass bans/kicks

3. **Access Control:**
   - Limit superadmin to 1-2 trusted individuals
   - Use admin role for day-to-day moderation
   - Regular review of admin list

4. **Updates:**
   - Keep GMod server updated
   - Monitor for security advisories
   - Review code changes before deployment

5. **Backups:**
   - Regular backups of sovereign.db
   - Test restore procedures
   - Off-site backup storage

## Future Security Considerations

When implementing UI:
1. Validate all client inputs on server
2. Use net messages instead of console commands
3. Implement CSRF protection for web panels
4. Rate limit UI requests
5. Authenticate UI access separately

## Compliance Notes

**GDPR Considerations:**
- System stores: SteamID, player names, IP addresses (in logs)
- Provides data through database queries
- Consider implementing data deletion on request
- Document retention policy

**Data Stored:**
- Player SteamID (identifier)
- Player nickname (public info)
- Admin actions (audit trail)
- Connection timestamps

**Data NOT Stored:**
- Passwords
- Email addresses
- Personal information beyond SteamID

## Security Contact

For security issues or questions:
1. Review this document
2. Check code for similar patterns
3. Test in development environment first
4. Report critical issues privately

## Conclusion

The Sovereign Admin System follows security best practices for a GMod admin addon:
- ✓ Input sanitization
- ✓ Permission enforcement
- ✓ Audit logging
- ✓ Error handling
- ✓ Secure defaults

No critical vulnerabilities identified. System is suitable for production use with recommended configurations.

**Last Updated:** December 26, 2025
**Reviewed By:** Automated Code Review + Manual Security Analysis
