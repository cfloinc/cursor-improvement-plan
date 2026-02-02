# Sync Credentials Skill

> Verify and test all credential connections.

---

## When to Use

Use this skill when:
- Starting work on a new machine
- Debugging authentication issues
- Verifying 1Password CLI setup
- Testing external service connections

---

## Instructions

### Step 1: Check 1Password CLI

```bash
# Check if op is installed
which op

# Check if signed in
op vault list 2>&1
```

**If not installed:**
```bash
brew install --cask 1password-cli
```

**If not signed in:**
```bash
eval $(op signin)
```

### Step 2: Verify Cursor Vault Access

```bash
# List items in Cursor vault
op item list --vault Cursor

# If empty or error, the vault may not exist or user needs to set it up
```

### Step 3: Test Common Credentials

Test each credential from UNIVERSAL_ACCESS.md:

**Bitbucket:**
```bash
# Get credential
BB_PWD=$(op item get "Bitbucket (cfloinc)" --vault Cursor --fields "App Password" 2>&1)

# Test connection (non-destructive)
if [[ "$BB_PWD" != *"error"* ]]; then
  curl -s -u "cfloinc:$BB_PWD" "https://api.bitbucket.org/2.0/user" | head -1
  echo "Bitbucket: ✅"
else
  echo "Bitbucket: ❌ - Could not retrieve credential"
fi
```

**GitHub:**
```bash
# Test SSH connection
ssh -T git@github.com 2>&1 | head -1
```

**DigitalOcean:**
```bash
DO_TOKEN=$(op item get "DigitalOcean API Token" --vault Cursor --fields credential 2>&1)

if [[ "$DO_TOKEN" != *"error"* ]]; then
  curl -s -H "Authorization: Bearer $DO_TOKEN" "https://api.digitalocean.com/v2/account" | head -1
  echo "DigitalOcean: ✅"
else
  echo "DigitalOcean: ❌ - Could not retrieve credential"
fi
```

**Confluence/Atlassian:**
```bash
ATLASSIAN_TOKEN=$(op item get "Atlassian API Token (Confluence)" --vault Cursor --fields credential 2>&1)

if [[ "$ATLASSIAN_TOKEN" != *"error"* ]]; then
  # Just verify we got the token, don't make API call without email
  echo "Atlassian token retrieved: ✅"
else
  echo "Atlassian: ❌ - Could not retrieve credential"
fi
```

### Step 4: Check UNIVERSAL_ACCESS.md

```bash
# Verify the file exists and is readable
if [[ -f ~/.cursor/credentials/UNIVERSAL_ACCESS.md ]]; then
  echo "UNIVERSAL_ACCESS.md: ✅"
  # Show services documented
  grep "^##" ~/.cursor/credentials/UNIVERSAL_ACCESS.md | head -10
else
  echo "UNIVERSAL_ACCESS.md: ❌ - File not found"
  echo "Expected at: ~/.cursor/credentials/UNIVERSAL_ACCESS.md"
fi
```

### Step 5: Generate Report

```markdown
## Credentials Health Check

**Date**: YYYY-MM-DD HH:MM
**Machine**: [hostname]

---

### 1Password CLI
| Check | Status |
|-------|--------|
| Installed | ✅/❌ |
| Signed in | ✅/❌ |
| Cursor vault accessible | ✅/❌ |

### Credentials
| Service | Credential Retrieved | Connection Test |
|---------|---------------------|-----------------|
| Bitbucket | ✅/❌ | ✅/❌ |
| GitHub (SSH) | N/A | ✅/❌ |
| DigitalOcean | ✅/❌ | ✅/❌ |
| Atlassian | ✅/❌ | ⚠️ (token only) |

### Reference Files
| File | Status |
|------|--------|
| ~/.cursor/credentials/UNIVERSAL_ACCESS.md | ✅/❌ |

---

### Issues Found
1. [Issue 1 with remediation]
2. [Issue 2 with remediation]

### All Systems Go?
**Status**: ✅ Ready / ❌ Issues to resolve
```

---

## Troubleshooting

### "op: command not found"

```bash
# Install 1Password CLI
brew install --cask 1password-cli

# Enable CLI integration
# 1Password app → Settings → Developer → Enable CLI
```

### "You are not currently signed in"

```bash
eval $(op signin)
```

### "Could not find vault Cursor"

The vault may be named differently. Check available vaults:
```bash
op vault list
```

### "Could not find item"

List items to find correct name:
```bash
op item list --vault Cursor
```

### GitHub SSH not working

```bash
# Check SSH key
ls ~/.ssh/id_ed25519 ~/.ssh/id_rsa 2>/dev/null

# Test connection with verbose
ssh -vT git@github.com

# If key exists but not added
ssh-add ~/.ssh/id_ed25519
```

### Bitbucket permission denied

- Use HTTPS with App Password, not SSH
- Verify username is `cfloinc` (workspace), not email
- Check App Password has required scopes

---

## Quick Health Check

Run this one-liner for a quick status:

```bash
echo "=== Credentials Health ===" && \
op vault list >/dev/null 2>&1 && echo "1Password: ✅" || echo "1Password: ❌" && \
ssh -T git@github.com 2>&1 | grep -q "success\|Hi" && echo "GitHub SSH: ✅" || echo "GitHub SSH: ❌" && \
test -f ~/.cursor/credentials/UNIVERSAL_ACCESS.md && echo "UNIVERSAL_ACCESS.md: ✅" || echo "UNIVERSAL_ACCESS.md: ❌"
```

---

## Example Interaction

**User:** "Check if my credentials are working"

**Agent:**
1. Verifies 1Password CLI is installed and signed in
2. Tests retrieval of each common credential
3. Tests actual connections where safe
4. Checks for UNIVERSAL_ACCESS.md
5. Reports status with clear pass/fail
6. Provides remediation steps for any failures
