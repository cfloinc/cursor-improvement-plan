# Credentials & Secrets Management

> How to access credentials without asking the user.

---

## The Golden Rule

**When you need credentials for ANY external service:**

1. Read `~/.cursor/credentials/UNIVERSAL_ACCESS.md`
2. Find the service you need
3. Use the 1Password item name provided
4. Retrieve with `op` CLI

**DO NOT:**
- Ask the user for credentials
- Search randomly for config files
- Guess at endpoints or connection strings
- Hardcode any secrets

---

## Quick Start

```bash
# Read the credentials file
cat ~/.cursor/credentials/UNIVERSAL_ACCESS.md

# Or search for a specific service
grep -A 20 "Confluence" ~/.cursor/credentials/UNIVERSAL_ACCESS.md
grep -A 20 "DigitalOcean" ~/.cursor/credentials/UNIVERSAL_ACCESS.md
grep -A 20 "Bitbucket" ~/.cursor/credentials/UNIVERSAL_ACCESS.md
```

---

## 1Password CLI

### Authentication

```bash
# Sign in (if commands fail)
eval $(op signin)

# Verify you're authenticated
op vault list
```

### First-Time Setup

If `op` commands fail completely:

1. Install 1Password CLI:
   ```bash
   brew install --cask 1password-cli
   ```

2. Enable CLI integration in 1Password app:
   - Open 1Password
   - Settings → Developer
   - Enable "Integrate with 1Password CLI"

3. Sign in:
   ```bash
   eval $(op signin)
   ```

---

## Retrieving Secrets

### Basic Pattern

```bash
# Get a specific field
op item get "Item Name" --vault Cursor --fields credential --reveal

# Get App Password (Bitbucket)
op item get "Bitbucket (cfloinc)" --vault Cursor --fields "App Password" --reveal

# Get full item as JSON
op item get "Item Name" --vault Cursor --format json
```

### Common Items

```bash
# Bitbucket
op item get "Bitbucket (cfloinc)" --vault Cursor --fields "App Password" --reveal

# DigitalOcean
op item get "DigitalOcean API Token" --vault Cursor --fields credential --reveal

# Confluence/Atlassian
op item get "Atlassian API Token (Confluence)" --vault Cursor --fields credential --reveal

# List all items in vault
op item list --vault Cursor
```

---

## Using Credentials

### In Shell Commands

```bash
# Clone Bitbucket repo (HTTPS)
git clone https://cfloinc:$(op item get "Bitbucket (cfloinc)" --vault Cursor --fields "App Password")@bitbucket.org/cfloinc/<repo>.git

# Use API token
curl -H "Authorization: Bearer $(op item get "API Token" --vault Cursor --fields credential)" \
  https://api.example.com/endpoint
```

### In Environment Variables

```bash
# Set temporarily for a command
DATABASE_URL=$(op item get "DB Credentials" --vault Cursor --fields url) npm run migrate

# Export for session
export API_KEY=$(op item get "API Key" --vault Cursor --fields credential)
```

### In .env Files (Local Only)

```bash
# Generate .env from 1Password (never commit this!)
echo "API_KEY=$(op item get 'API Key' --vault Cursor --fields credential)" >> .env
```

---

## Vaults

| Vault | Purpose |
|-------|---------|
| `Cursor` | Development credentials (API tokens, service accounts) |
| `Private` | Personal account logins |

Always use `--vault Cursor` for development credentials.

---

## Credential Workflow

### Pattern: Access External Service

```bash
# 1. Check UNIVERSAL_ACCESS.md for the service
grep -A 15 "ServiceName" ~/.cursor/credentials/UNIVERSAL_ACCESS.md

# 2. Note the 1Password item name from the output
# Example output: "API Token: 1Password (Cursor vault) → 'Service API Token'"

# 3. Retrieve it
TOKEN=$(op item get "Service API Token" --vault Cursor --fields credential --reveal)

# 4. Use it
curl -H "Authorization: Bearer $TOKEN" https://api.service.com/endpoint
```

### Pattern: Clone Private Repository

```bash
# Bitbucket (use HTTPS, not SSH)
git clone https://cfloinc:$(op item get "Bitbucket (cfloinc)" --vault Cursor --fields "App Password")@bitbucket.org/cfloinc/repo-name.git

# GitHub (SSH works fine)
git clone git@github.com:cfloinc/repo-name.git
```

---

## Security Rules

### Never Do

- Commit `.env` files with real values
- Echo credentials to logs
- Store credentials in code comments
- Share credentials via chat/email
- Use credentials from untrusted sources

### Always Do

- Use `.env.example` for templates (no real values)
- Verify `.gitignore` includes credential files
- Rotate credentials if accidentally exposed
- Use the minimum scope/permissions needed

### .gitignore Must Include

```gitignore
.env
.env.*
!.env.example
*.key
*.pem
*.p12
credentials.json
secrets.json
```

---

## Troubleshooting

### "op: command not found"

```bash
brew install --cask 1password-cli
```

### "You are not currently signed in"

```bash
eval $(op signin)
```

### "Could not find item"

1. Check vault name is correct (`--vault Cursor`)
2. Verify item name matches exactly (case-sensitive)
3. List items to find correct name:
   ```bash
   op item list --vault Cursor
   ```

### "Permission denied" on Git clone

Use HTTPS with App Password instead of SSH:
```bash
git clone https://cfloinc:$(op item get "Bitbucket (cfloinc)" --vault Cursor --fields "App Password")@bitbucket.org/cfloinc/repo.git
```

---

## Self-Sufficient Agent Behavior

When you need credentials:

1. **First**: Read `~/.cursor/credentials/UNIVERSAL_ACCESS.md`
2. **Then**: Use `op` CLI to retrieve
3. **Never**: Ask the user or search randomly

The user expects you to handle credential access autonomously using these resources.

---

*All credentials are managed through 1Password. The UNIVERSAL_ACCESS.md file is the index.*
