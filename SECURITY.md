# Security Guidelines - Flutter IDV

## 🔐 Configuration File Security

### ⚠️ CRITICAL: Never Commit Real Secrets

This project uses a template-based configuration system to protect sensitive credentials:

### 📁 File Structure

```
config.example.json    ← Template file (SAFE to commit)
config.json           ← Real secrets (NEVER commit)
```

### 🔒 How It Works

1. **`config.example.json`**: 
   - Contains placeholder values
   - Safe to commit to version control
   - Used as a template for real configuration

2. **`config.json`**: 
   - Contains your actual API keys and secrets
   - **AUTOMATICALLY EXCLUDED** from Git via `.gitignore`
   - Created by copying and editing the example file

### 🚨 Security Rules

#### ✅ DO:
- Keep real secrets in `config.json` only
- Use placeholder values in `config.example.json`
- Copy example to create your config: `cp config.example.json config.json`
- Edit `config.json` with your real credentials
- Commit `config.example.json` with placeholders

#### ❌ DON'T:
- Put real API keys in `config.example.json`
- Commit `config.json` to version control
- Share `config.json` in chat, email, or public channels
- Hardcode secrets in source code

### 📋 Setup Process

1. **Copy the template:**
   ```bash
   cp config.example.json config.json
   ```

2. **Edit with real credentials:**
   ```json
   {
     "api_config": {
       "base_url": "https://scs-ol-demo.rnd.gemaltodigitalbankingidcloud.com/scs/v1",
       "x_api_key": "your-real-api-key-here",
       "jwt_token": "your-real-jwt-token-here"
     },
     "acuant_config": {
       "passive_username": "your-real-username",
       "passive_password": "your-real-password",
       // ... other real credentials
     }
   }
   ```

3. **Verify exclusion:**
   ```bash
   git status  # config.json should NOT appear
   ```

### 🛡️ Protected Files

The following files are automatically excluded from Git:

```gitignore
# Configuration files with sensitive data - NEVER COMMIT THESE!
config.json               # Contains real API keys and secrets
*.env                     # Environment variables
.env*                     # Environment variable files
secrets.json              # Any secrets file
credentials.json          # Any credentials file
*.pem                     # Private keys
*.key                     # Private keys
```

### 🔍 Verification Checklist

Before committing code, always verify:

- [ ] `config.example.json` contains only placeholder values
- [ ] `config.json` is excluded from Git status
- [ ] No real API keys are in committed files
- [ ] Placeholder values are clearly marked (e.g., `YOUR_API_KEY_HERE`)

### 🚨 If You Accidentally Commit Secrets

If you accidentally commit real secrets:

1. **Immediate action:**
   ```bash
   # Remove from Git history (if just committed)
   git reset --soft HEAD~1
   git reset HEAD config.json
   ```

2. **Rotate credentials:**
   - Change all exposed API keys immediately
   - Generate new JWT tokens
   - Update passwords

3. **Clean history (if needed):**
   ```bash
   # For already pushed commits, use git filter-branch or BFG Repo-Cleaner
   # Consult Git documentation for history rewriting
   ```

### 📞 Support

For security questions or incidents:
- Review this document first
- Check `.gitignore` configuration
- Verify file exclusions with `git status`
- Rotate any potentially exposed credentials

### 🔄 Credential Rotation

Regularly rotate your credentials:
- JWT tokens should be refreshed periodically
- API keys should be rotated according to your security policy
- Monitor for any unauthorized usage

---

**Remember: Security is everyone's responsibility. When in doubt, don't commit!** 