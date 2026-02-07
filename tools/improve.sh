#!/bin/bash
# =============================================================================
# Cursor Improvement Plan - Project Improvement Script
# =============================================================================
# Usage: ./improve.sh [project-path]
# Example: ./improve.sh ~/projects/my-app
#
# Audits an existing project and non-destructively adds missing structure,
# documentation, rules, and configuration.
# =============================================================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
IMPROVE_DIR="$(dirname "$SCRIPT_DIR")"
TEMPLATES_DIR="$IMPROVE_DIR/templates"

# Counters
ADDED=0
SKIPPED=0

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

print_added() {
    echo -e "${GREEN}+ Added${NC} $1"
    ((++ADDED))
}

print_skipped() {
    echo -e "${YELLOW}= Skipped${NC} $1 (already exists)"
    ((++SKIPPED))
}

print_info() { echo -e "${BLUE}i${NC} $1"; }
print_success() { echo -e "${GREEN}✓${NC} $1"; }
print_warning() { echo -e "${YELLOW}⚠${NC} $1"; }

# =============================================================================
# Stack Detection
# =============================================================================

detect_stack() {
    if [[ -f "$TARGET_DIR/package.json" ]]; then
        if grep -q '"next"' "$TARGET_DIR/package.json" 2>/dev/null; then
            STACK="nextjs"
        else
            STACK="node"
        fi
    elif [[ -f "$TARGET_DIR/requirements.txt" ]] || [[ -f "$TARGET_DIR/pyproject.toml" ]] || [[ -f "$TARGET_DIR/setup.py" ]]; then
        STACK="python"
    elif [[ -f "$TARGET_DIR/composer.json" ]]; then
        STACK="laravel"
    elif [[ -f "$TARGET_DIR/Package.swift" ]] || ls "$TARGET_DIR"/*.xcodeproj 2>/dev/null | grep -q .; then
        STACK="swift"
    else
        STACK="generic"
    fi

    print_info "Detected stack: ${CYAN}$STACK${NC}"
}

# =============================================================================
# Improvement Functions
# =============================================================================

add_dir_if_missing() {
    local dir="$1"
    local desc="$2"

    if [[ -d "$TARGET_DIR/$dir" ]]; then
        print_skipped "$desc ($dir/)"
    else
        mkdir -p "$TARGET_DIR/$dir"
        print_added "$desc ($dir/)"
    fi
}

add_file_if_missing() {
    local src="$1"
    local dest="$2"
    local desc="$3"

    if [[ -f "$TARGET_DIR/$dest" ]]; then
        print_skipped "$desc ($dest)"
    else
        if [[ -f "$src" ]]; then
            # Ensure parent directory exists
            mkdir -p "$(dirname "$TARGET_DIR/$dest")"
            cp "$src" "$TARGET_DIR/$dest"
            print_added "$desc ($dest)"
        else
            print_warning "Source not found: $src"
        fi
    fi
}

improve_directory_structure() {
    print_info "Checking directory structure..."
    echo ""

    add_dir_if_missing "docs" "Documentation directory"
    add_dir_if_missing "docs/tasks" "Task tracking directory"
    add_dir_if_missing "docs/notes" "Session notes directory"
    add_dir_if_missing "tests" "Tests directory"
    add_dir_if_missing ".cursor/rules" "Cursor rules directory"
    echo ""
}

improve_documentation() {
    print_info "Checking documentation..."
    echo ""

    # Core agent files
    add_file_if_missing "$IMPROVE_DIR/AGENT.md" "AGENT.md" "Agent reference guide"
    add_file_if_missing "$TEMPLATES_DIR/project/SCRATCHPAD.md.template" "SCRATCHPAD.md" "Agent self-learning log"

    # Documentation templates
    add_file_if_missing "$TEMPLATES_DIR/project/PROJECT.md.template" "docs/PROJECT.md" "Project overview"
    add_file_if_missing "$TEMPLATES_DIR/project/ARCHITECTURE.md.template" "docs/ARCHITECTURE.md" "Architecture doc"
    add_file_if_missing "$TEMPLATES_DIR/project/SETUP.md.template" "docs/SETUP.md" "Setup guide"
    add_file_if_missing "$TEMPLATES_DIR/project/DECISIONS.md.template" "docs/DECISIONS.md" "Decision records"
    add_file_if_missing "$TEMPLATES_DIR/project/CHANGELOG.md.template" "docs/CHANGELOG.md" "Changelog"
    echo ""
}

improve_gitignore() {
    print_info "Checking .gitignore..."
    echo ""

    if [[ ! -f "$TARGET_DIR/.gitignore" ]]; then
        cp "$TEMPLATES_DIR/project/.gitignore.template" "$TARGET_DIR/.gitignore"
        print_added ".gitignore"
    else
        print_skipped ".gitignore"

        # Ensure critical security patterns are present
        local appended=false
        if ! grep -q "^\.env$" "$TARGET_DIR/.gitignore" 2>/dev/null; then
            echo -e "\n# Added by Cursor Improvement Plan\n.env" >> "$TARGET_DIR/.gitignore"
            appended=true
        fi
        if ! grep -q "^\*\.key$" "$TARGET_DIR/.gitignore" 2>/dev/null; then
            echo "*.key" >> "$TARGET_DIR/.gitignore"
            appended=true
        fi
        if ! grep -q "^\*\.pem$" "$TARGET_DIR/.gitignore" 2>/dev/null; then
            echo "*.pem" >> "$TARGET_DIR/.gitignore"
            appended=true
        fi

        if [[ "$appended" == true ]]; then
            print_success "Appended missing security patterns to .gitignore"
        else
            print_success ".gitignore already has essential security patterns"
        fi
    fi
    echo ""
}

improve_env_example() {
    print_info "Checking .env.example..."
    echo ""

    if [[ ! -f "$TARGET_DIR/.env.example" ]]; then
        local project_name=$(basename "$TARGET_DIR")
        cat > "$TARGET_DIR/.env.example" << EOF
# =============================================================================
# $project_name Environment Variables
# =============================================================================
# Copy this file to .env and fill in the values
# NEVER commit .env to git!
# =============================================================================

# Application
APP_NAME="$project_name"
APP_ENV=local
APP_DEBUG=true

# Database (if needed)
# DB_HOST=127.0.0.1
# DB_PORT=5432
# DB_DATABASE=$project_name
# DB_USERNAME=
# DB_PASSWORD=

# External Services (get from 1Password)
# API_KEY=
# API_SECRET=
EOF
        print_added ".env.example"
    else
        print_skipped ".env.example"
    fi
    echo ""
}

improve_stack_rules() {
    print_info "Checking stack-specific rules..."
    echo ""

    local stack_dir="$TEMPLATES_DIR/stacks/$STACK"
    local rules_dir="$TARGET_DIR/.cursor/rules"

    if [[ -d "$stack_dir" ]]; then
        for file in "$stack_dir"/*.md; do
            if [[ -f "$file" ]]; then
                local filename=$(basename "$file")
                add_file_if_missing "$file" ".cursor/rules/$filename" "Stack rule: $filename"
            fi
        done
    else
        # Generic fallback: add core rules if no rules exist at all
        if [[ -z "$(ls -A "$rules_dir" 2>/dev/null)" ]]; then
            cp "$IMPROVE_DIR/core/COMMANDMENTS.md" "$rules_dir/core.md"
            print_added "Generic core rules (.cursor/rules/core.md)"
        else
            print_skipped "Stack rules (existing rules found in .cursor/rules/)"
        fi
    fi
    echo ""
}

replace_placeholders() {
    print_info "Customizing templates..."

    local project_name=$(basename "$TARGET_DIR")
    local today=$(date +%Y-%m-%d)

    # Only process .md files that we likely just created (not all files in the project)
    local files_to_process=(
        "$TARGET_DIR/AGENT.md"
        "$TARGET_DIR/SCRATCHPAD.md"
        "$TARGET_DIR/docs/PROJECT.md"
        "$TARGET_DIR/docs/ARCHITECTURE.md"
        "$TARGET_DIR/docs/SETUP.md"
        "$TARGET_DIR/docs/DECISIONS.md"
        "$TARGET_DIR/docs/CHANGELOG.md"
    )

    for file in "${files_to_process[@]}"; do
        if [[ -f "$file" ]]; then
            if grep -q "\[Project Name\]" "$file" 2>/dev/null; then
                if [[ "$(uname)" == "Darwin" ]]; then
                    sed -i '' "s/\[Project Name\]/$project_name/g" "$file" 2>/dev/null || true
                    sed -i '' "s/YYYY-MM-DD/$today/g" "$file" 2>/dev/null || true
                else
                    sed -i "s/\[Project Name\]/$project_name/g" "$file" 2>/dev/null || true
                    sed -i "s/YYYY-MM-DD/$today/g" "$file" 2>/dev/null || true
                fi
            fi
        fi
    done

    print_success "Placeholders replaced"
    echo ""
}

# =============================================================================
# Main
# =============================================================================

main() {
    TARGET_DIR="${1:-$(pwd)}"

    # Resolve absolute path
    TARGET_DIR="$(cd "$TARGET_DIR" 2>/dev/null && pwd)" || {
        echo -e "${RED}Error: Directory '$1' not found${NC}"
        exit 1
    }

    local project_name=$(basename "$TARGET_DIR")

    print_header "Cursor Improvement Plan - Project Upgrade"
    echo "Project:  $project_name"
    echo "Path:     $TARGET_DIR"
    echo ""

    # Detect stack
    detect_stack
    echo ""

    # Run improvements
    improve_directory_structure
    improve_documentation
    improve_gitignore
    improve_env_example
    improve_stack_rules
    replace_placeholders

    # Run validation
    if [[ -x "$SCRIPT_DIR/validate.sh" ]]; then
        print_header "Validation"
        "$SCRIPT_DIR/validate.sh" "$TARGET_DIR" 2>/dev/null || true
    fi

    # Summary
    print_header "Improvement Complete!"

    echo -e "${GREEN}Added:${NC}   $ADDED items"
    echo -e "${YELLOW}Skipped:${NC} $SKIPPED items (already existed)"
    echo ""
    echo "Stack detected: $STACK"
    echo ""
    echo "Next steps:"
    echo "  1. Review any newly added docs/ files and fill in project-specific details"
    echo "  2. Review and customize .cursor/rules/"
    echo "  3. Start using SCRATCHPAD.md at the end of each session"
    echo "  4. Run: cursor . (to open in Cursor)"
    echo ""

    print_success "Project improved!"
}

main "$@"
