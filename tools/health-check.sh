#!/bin/bash
# =============================================================================
# Cursor Improvement Plan - Health Check Script
# =============================================================================
# Usage: ./health-check.sh
#
# Verifies system setup: 1Password CLI, Git access, credentials file.
# =============================================================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Counters
PASS=0
FAIL=0

# =============================================================================
# Helper Functions
# =============================================================================

print_header() {
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}  $1${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

check_pass() {
    echo -e "${GREEN}✓${NC} $1"
    ((++PASS))
}

check_fail() {
    echo -e "${RED}✗${NC} $1"
    ((++FAIL))
}

check_warn() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

# =============================================================================
# Checks
# =============================================================================

check_1password_cli() {
    echo "1Password CLI"
    echo "─────────────"
    
    # Check if installed
    if command -v op &> /dev/null; then
        check_pass "1Password CLI installed"
        
        # Check if signed in
        if op vault list &> /dev/null; then
            check_pass "1Password CLI signed in"
            
            # Check Cursor vault
            if op vault get Cursor &> /dev/null; then
                check_pass "Cursor vault accessible"
            else
                check_fail "Cursor vault not found"
                print_info "Create a vault named 'Cursor' in 1Password"
            fi
        else
            check_fail "1Password CLI not signed in"
            print_info "Run: eval \$(op signin)"
        fi
    else
        check_fail "1Password CLI not installed"
        print_info "Run: brew install --cask 1password-cli"
    fi
    echo ""
}

check_git_access() {
    echo "Git Access"
    echo "──────────"
    
    # Check git installed
    if command -v git &> /dev/null; then
        check_pass "Git installed"
    else
        check_fail "Git not installed"
        return
    fi
    
    # Check GitHub SSH
    if ssh -T git@github.com 2>&1 | grep -qi "success\|hi\|authenticated"; then
        check_pass "GitHub SSH access"
    else
        check_warn "GitHub SSH may not be configured"
        print_info "Test: ssh -T git@github.com"
    fi
    
    # Check Bitbucket (via 1Password if available)
    if command -v op &> /dev/null && op vault list &> /dev/null; then
        local bb_pwd=$(op item get "Bitbucket (cfloinc)" --vault Cursor --fields "App Password" 2>&1)
        if [[ "$bb_pwd" != *"error"* && "$bb_pwd" != *"could not"* ]]; then
            # Test the credential
            local bb_test=$(curl -s -o /dev/null -w "%{http_code}" -u "cfloinc:$bb_pwd" "https://api.bitbucket.org/2.0/user" 2>&1)
            if [[ "$bb_test" == "200" ]]; then
                check_pass "Bitbucket access (via App Password)"
            else
                check_warn "Bitbucket credential found but connection failed"
            fi
        else
            check_warn "Bitbucket credential not found in 1Password"
        fi
    fi
    echo ""
}

check_credentials_file() {
    echo "Credentials File"
    echo "────────────────"
    
    local cred_file="$HOME/.cursor/credentials/UNIVERSAL_ACCESS.md"
    
    if [[ -f "$cred_file" ]]; then
        check_pass "UNIVERSAL_ACCESS.md exists"
        
        # Check if it has content
        local lines=$(wc -l < "$cred_file" | tr -d ' ')
        if [[ "$lines" -gt 20 ]]; then
            check_pass "UNIVERSAL_ACCESS.md has content ($lines lines)"
        else
            check_warn "UNIVERSAL_ACCESS.md appears minimal"
        fi
    else
        check_fail "UNIVERSAL_ACCESS.md not found"
        print_info "Expected at: $cred_file"
    fi
    echo ""
}

check_improvement_plan() {
    echo "Improvement Plan"
    echo "────────────────"
    
    local improve_dir="$HOME/Cursor/cursor-improvement-plan"
    
    if [[ -d "$improve_dir" ]]; then
        check_pass "Improvement Plan directory exists"
        
        # Check key files
        [[ -f "$improve_dir/AGENT.md" ]] && check_pass "AGENT.md exists" || check_warn "AGENT.md missing"
        [[ -f "$improve_dir/IMPROVEMENT.md" ]] && check_pass "IMPROVEMENT.md exists" || check_warn "IMPROVEMENT.md missing"
        [[ -d "$improve_dir/core" ]] && check_pass "core/ exists" || check_warn "core/ missing"
        [[ -d "$improve_dir/skills" ]] && check_pass "skills/ exists" || check_warn "skills/ missing"
        [[ -d "$improve_dir/templates" ]] && check_pass "templates/ exists" || check_warn "templates/ missing"
    else
        check_warn "Improvement Plan not at expected location"
        print_info "Expected at: $improve_dir"
    fi
    echo ""
}

check_common_tools() {
    echo "Common Tools"
    echo "────────────"
    
    # Node/npm
    if command -v node &> /dev/null; then
        local node_ver=$(node --version)
        check_pass "Node.js installed ($node_ver)"
    else
        check_warn "Node.js not installed"
    fi
    
    # Python
    if command -v python3 &> /dev/null; then
        local py_ver=$(python3 --version)
        check_pass "Python installed ($py_ver)"
    else
        check_warn "Python not installed"
    fi
    
    # Docker
    if command -v docker &> /dev/null; then
        if docker info &> /dev/null; then
            check_pass "Docker installed and running"
        else
            check_warn "Docker installed but not running"
        fi
    else
        check_warn "Docker not installed"
    fi
    echo ""
}

# =============================================================================
# Summary
# =============================================================================

print_summary() {
    print_header "Health Check Summary"
    
    local total=$((PASS + FAIL))
    
    echo -e "${GREEN}Passed:${NC} $PASS"
    echo -e "${RED}Failed:${NC} $FAIL"
    echo ""
    
    if [[ $FAIL -eq 0 ]]; then
        echo -e "${GREEN}✓ All systems ready!${NC}"
        return 0
    else
        echo -e "${RED}⚠ Some issues need attention.${NC}"
        echo ""
        echo "Common fixes:"
        echo "  1Password: brew install --cask 1password-cli && eval \$(op signin)"
        echo "  GitHub SSH: ssh-keygen -t ed25519 && ssh-add ~/.ssh/id_ed25519"
        return 1
    fi
}

# =============================================================================
# Main
# =============================================================================

main() {
    print_header "Cursor Improvement Plan - Health Check"
    
    echo "Date: $(date '+%Y-%m-%d %H:%M:%S')"
    echo "Host: $(hostname)"
    echo ""
    
    check_1password_cli
    check_git_access
    check_credentials_file
    check_improvement_plan
    check_common_tools
    
    print_summary
}

main "$@"
