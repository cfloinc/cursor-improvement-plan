#!/bin/bash
# =============================================================================
# Cursor Starter Loop - Project Validation Script
# =============================================================================
# Usage: ./validate.sh [project-path]
# Example: ./validate.sh ~/projects/my-app
#
# Checks if a project follows Starter Loop conventions.
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
WARN=0
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

check_warn() {
    echo -e "${YELLOW}⚠${NC} $1"
    ((++WARN))
}

check_fail() {
    echo -e "${RED}✗${NC} $1"
    ((++FAIL))
}

# =============================================================================
# Validation Checks
# =============================================================================

check_file_exists() {
    local file="$1"
    local required="$2"
    local desc="$3"
    
    if [[ -f "$PROJECT_DIR/$file" ]]; then
        check_pass "$desc exists"
        return 0
    else
        if [[ "$required" == "required" ]]; then
            check_fail "$desc is missing ($file)"
        else
            check_warn "$desc is missing ($file)"
        fi
        return 1
    fi
}

check_dir_exists() {
    local dir="$1"
    local required="$2"
    local desc="$3"
    
    if [[ -d "$PROJECT_DIR/$dir" ]]; then
        check_pass "$desc exists"
        return 0
    else
        if [[ "$required" == "required" ]]; then
            check_fail "$desc is missing ($dir)"
        else
            check_warn "$desc is missing ($dir)"
        fi
        return 1
    fi
}

check_file_has_content() {
    local file="$1"
    local desc="$2"
    local min_lines="${3:-10}"
    
    if [[ -f "$PROJECT_DIR/$file" ]]; then
        local lines=$(wc -l < "$PROJECT_DIR/$file" | tr -d ' ')
        if [[ "$lines" -gt "$min_lines" ]]; then
            check_pass "$desc has content ($lines lines)"
            return 0
        else
            check_warn "$desc appears to be placeholder ($lines lines)"
            return 1
        fi
    fi
    return 1
}

check_gitignore_patterns() {
    local gitignore="$PROJECT_DIR/.gitignore"
    
    if [[ ! -f "$gitignore" ]]; then
        check_fail ".gitignore is missing"
        return 1
    fi
    
    local patterns=(".env" "*.key" "*.pem" "node_modules" "__pycache__")
    local missing=()
    
    for pattern in "${patterns[@]}"; do
        if ! grep -q "$pattern" "$gitignore" 2>/dev/null; then
            missing+=("$pattern")
        fi
    done
    
    if [[ ${#missing[@]} -eq 0 ]]; then
        check_pass ".gitignore has essential patterns"
    else
        check_warn ".gitignore missing: ${missing[*]}"
    fi
}

check_no_secrets_in_git() {
    if [[ ! -d "$PROJECT_DIR/.git" ]]; then
        echo -e "${BLUE}ℹ${NC} Not a git repo, skipping secrets check"
        return 0
    fi
    
    local found_secrets=false
    
    # Check for .env in git
    if git -C "$PROJECT_DIR" ls-files .env 2>/dev/null | grep -q ".env"; then
        check_fail "🔴 CRITICAL: .env file is tracked in git!"
        found_secrets=true
    fi
    
    # Check for key/pem files
    if git -C "$PROJECT_DIR" ls-files "*.key" "*.pem" 2>/dev/null | grep -q .; then
        check_fail "🔴 CRITICAL: Secret files (.key/.pem) tracked in git!"
        found_secrets=true
    fi
    
    if [[ "$found_secrets" == false ]]; then
        check_pass "No secrets tracked in git"
    fi
}

check_cursorrules() {
    if [[ -f "$PROJECT_DIR/.cursorrules" ]]; then
        check_pass ".cursorrules exists"
        local lines=$(wc -l < "$PROJECT_DIR/.cursorrules" | tr -d ' ')
        if [[ "$lines" -lt 20 ]]; then
            check_warn ".cursorrules is minimal ($lines lines)"
        fi
    elif [[ -d "$PROJECT_DIR/.cursor/rules" ]]; then
        local count=$(find "$PROJECT_DIR/.cursor/rules" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
        if [[ "$count" -gt 0 ]]; then
            check_pass ".cursor/rules/ has $count rule file(s)"
        else
            check_warn ".cursor/rules/ exists but empty"
        fi
    else
        check_warn "No .cursorrules or .cursor/rules/ found"
    fi
}

check_env_setup() {
    if [[ -f "$PROJECT_DIR/.env.example" ]]; then
        check_pass ".env.example exists"
        
        if [[ -f "$PROJECT_DIR/.env" ]]; then
            check_pass ".env exists for local dev"
        else
            check_warn ".env not found - copy from .env.example"
        fi
    else
        check_warn ".env.example missing"
    fi
}

# =============================================================================
# Main Validation
# =============================================================================

validate_project() {
    print_header "Validating: $(basename $PROJECT_DIR)"
    
    echo "Structure"
    echo "─────────"
    check_dir_exists "docs" "recommended" "docs/"
    check_dir_exists "src" "recommended" "src/"
    check_dir_exists "tests" "recommended" "tests/"
    check_dir_exists "docs/tasks" "recommended" "docs/tasks/"
    check_dir_exists "docs/notes" "recommended" "docs/notes/"
    echo ""
    
    echo "Documentation"
    echo "─────────────"
    check_file_exists "README.md" "required" "README.md"
    check_file_exists "AGENT.md" "recommended" "AGENT.md"
    check_file_exists "SCRATCHPAD.md" "recommended" "SCRATCHPAD.md"
    check_file_exists "docs/PROJECT.md" "recommended" "docs/PROJECT.md"
    check_file_exists "docs/ARCHITECTURE.md" "recommended" "docs/ARCHITECTURE.md"
    check_file_exists "docs/SETUP.md" "recommended" "docs/SETUP.md"
    check_file_exists "docs/CHANGELOG.md" "recommended" "docs/CHANGELOG.md"
    echo ""
    
    echo "Documentation Content"
    echo "─────────────────────"
    check_file_has_content "README.md" "README.md"
    check_file_has_content "docs/PROJECT.md" "docs/PROJECT.md"
    echo ""
    
    echo "Configuration"
    echo "─────────────"
    check_file_exists ".gitignore" "required" ".gitignore"
    check_gitignore_patterns
    check_env_setup
    check_cursorrules
    echo ""
    
    echo "Security"
    echo "────────"
    check_no_secrets_in_git
    echo ""
}

print_summary() {
    print_header "Validation Summary"
    
    echo -e "${GREEN}Passed:${NC}   $PASS"
    echo -e "${YELLOW}Warnings:${NC} $WARN"
    echo -e "${RED}Failed:${NC}   $FAIL"
    echo ""
    
    local total=$((PASS + WARN + FAIL))
    if [[ $total -gt 0 ]]; then
        local score=$((PASS * 100 / total))
        echo "Score: $score% ($PASS/$total checks passed)"
    fi
    echo ""
    
    if [[ $FAIL -gt 0 ]]; then
        echo -e "${RED}⚠ Project has issues that should be fixed.${NC}"
        return 1
    elif [[ $WARN -gt 0 ]]; then
        echo -e "${YELLOW}Project is functional but could be improved.${NC}"
        return 0
    else
        echo -e "${GREEN}✓ Project follows all Starter Loop conventions!${NC}"
        return 0
    fi
}

# =============================================================================
# Main
# =============================================================================

main() {
    PROJECT_DIR="${1:-$(pwd)}"
    
    # Resolve absolute path
    PROJECT_DIR="$(cd "$PROJECT_DIR" 2>/dev/null && pwd)" || {
        echo -e "${RED}Error: Directory '$1' not found${NC}"
        exit 1
    }
    
    validate_project
    print_summary
}

main "$@"
