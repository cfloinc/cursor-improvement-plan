#!/bin/bash
# =============================================================================
# Cursor Starter Loop - Project Initialization Script
# =============================================================================
# Usage: ./init.sh [project-name] [stack]
# Example: ./init.sh my-app python
#
# Scaffolds a new project with the standard structure and templates.
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
STARTER_DIR="$(dirname "$SCRIPT_DIR")"
TEMPLATES_DIR="$STARTER_DIR/templates"

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

print_success() { echo -e "${GREEN}✓${NC} $1"; }
print_warning() { echo -e "${YELLOW}⚠${NC} $1"; }
print_error() { echo -e "${RED}✗${NC} $1"; }
print_info() { echo -e "${BLUE}ℹ${NC} $1"; }

# =============================================================================
# Validation
# =============================================================================

validate_project_name() {
    local name="$1"
    if [[ ! "$name" =~ ^[a-zA-Z][a-zA-Z0-9_-]*$ ]]; then
        print_error "Invalid project name. Use alphanumeric, hyphens, underscores."
        print_info "Example: my-project, myProject, my_project"
        exit 1
    fi
}

# =============================================================================
# Interactive Prompts
# =============================================================================

prompt_project_name() {
    if [[ -n "$1" ]]; then
        PROJECT_NAME="$1"
    else
        read -p "Project name: " PROJECT_NAME
    fi
    validate_project_name "$PROJECT_NAME"
}

prompt_stack() {
    if [[ -n "$1" ]]; then
        STACK="$1"
    else
        echo ""
        echo "Available stacks:"
        echo "  1) generic   - No specific framework"
        echo "  2) python    - Python/FastAPI/Django"
        echo "  3) node      - Node.js/TypeScript"
        echo "  4) nextjs    - Next.js React"
        echo "  5) laravel   - PHP Laravel"
        echo "  6) swift     - Swift/macOS/Xcode"
        echo ""
        read -p "Select stack [1-6, default: 1]: " stack_choice
        
        case "$stack_choice" in
            2|python)  STACK="python" ;;
            3|node)    STACK="node" ;;
            4|nextjs)  STACK="nextjs" ;;
            5|laravel) STACK="laravel" ;;
            6|swift)   STACK="swift" ;;
            *)         STACK="generic" ;;
        esac
    fi
}

prompt_git_init() {
    read -p "Initialize git repository? [Y/n]: " git_choice
    case "$git_choice" in
        [nN]*) INIT_GIT=false ;;
        *)     INIT_GIT=true ;;
    esac
}

prompt_target_dir() {
    read -p "Target directory [./$PROJECT_NAME]: " target_dir
    TARGET_DIR="${target_dir:-./$PROJECT_NAME}"
}

# =============================================================================
# Scaffolding Functions
# =============================================================================

create_directory_structure() {
    print_info "Creating directory structure..."
    
    mkdir -p "$TARGET_DIR/docs/tasks"
    mkdir -p "$TARGET_DIR/docs/notes"
    mkdir -p "$TARGET_DIR/src"
    mkdir -p "$TARGET_DIR/tests"
    mkdir -p "$TARGET_DIR/.cursor/rules"
    
    print_success "Directory structure created"
}

copy_core_templates() {
    print_info "Copying core templates..."
    
    local templates=(
        "project/PROJECT.md.template:docs/PROJECT.md"
        "project/ARCHITECTURE.md.template:docs/ARCHITECTURE.md"
        "project/SETUP.md.template:docs/SETUP.md"
        "project/DECISIONS.md.template:docs/DECISIONS.md"
        "project/CHANGELOG.md.template:docs/CHANGELOG.md"
        "project/README.md.template:README.md"
        "project/.gitignore.template:.gitignore"
        "project/SCRATCHPAD.md.template:SCRATCHPAD.md"
    )
    
    for template in "${templates[@]}"; do
        local src="${template%%:*}"
        local dest="${template##*:}"
        
        if [[ -f "$TEMPLATES_DIR/$src" ]]; then
            cp "$TEMPLATES_DIR/$src" "$TARGET_DIR/$dest"
            print_success "Created $dest"
        else
            print_warning "Template not found: $src"
        fi
    done
    
    # Create .env.example
    cat > "$TARGET_DIR/.env.example" << EOF
# =============================================================================
# $PROJECT_NAME Environment Variables
# =============================================================================
# Copy this file to .env and fill in the values
# NEVER commit .env to git!
# =============================================================================

# Application
APP_NAME="$PROJECT_NAME"
APP_ENV=local
APP_DEBUG=true

# Database (if needed)
# DB_HOST=127.0.0.1
# DB_PORT=5432
# DB_DATABASE=$PROJECT_NAME
# DB_USERNAME=
# DB_PASSWORD=

# External Services (get from 1Password)
# API_KEY=
# API_SECRET=
EOF
    print_success "Created .env.example"
}

copy_stack_templates() {
    local stack_dir="$TEMPLATES_DIR/stacks/$STACK"
    
    if [[ -d "$stack_dir" ]]; then
        print_info "Copying $STACK stack templates..."
        
        # Copy all .md files to .cursor/rules/
        for file in "$stack_dir"/*.md; do
            if [[ -f "$file" ]]; then
                local filename=$(basename "$file")
                cp "$file" "$TARGET_DIR/.cursor/rules/$filename"
                print_success "Created .cursor/rules/$filename"
            fi
        done
        
        # Copy other stack files to project root
        for file in "$stack_dir"/*; do
            if [[ -f "$file" && ! "$file" =~ \.md$ ]]; then
                local filename=$(basename "$file")
                local destname="${filename%.template}"
                cp "$file" "$TARGET_DIR/$destname"
                print_success "Created $destname"
            fi
        done
    else
        print_info "No stack-specific templates for '$STACK', using generic rules"
        # Copy generic rules
        cat > "$TARGET_DIR/.cursor/rules/core.md" << 'EOF'
# Project Rules

## The 10 Commandments

1. Read before writing
2. Small commits, often
3. Document the "why"
4. Test your changes
5. Ask before breaking changes
6. Use conventional commits
7. Keep secrets out of git
8. Update docs with code
9. Progress over perfection
10. Communicate blockers early

## Stop and Ask Before

- Deleting files or directories
- Changing authentication logic
- Modifying database schemas
- Altering CI/CD pipelines
- Refactoring core architecture

## Credentials

For any external service, read:
```
~/.cursor/credentials/UNIVERSAL_ACCESS.md
```
EOF
        print_success "Created .cursor/rules/core.md"
    fi
}

replace_placeholders() {
    print_info "Customizing templates..."
    
    local today=$(date +%Y-%m-%d)
    
    # Replace placeholders in all markdown files
    find "$TARGET_DIR" -name "*.md" -type f | while read -r file; do
        if [[ "$(uname)" == "Darwin" ]]; then
            sed -i '' "s/\[Project Name\]/$PROJECT_NAME/g" "$file" 2>/dev/null || true
            sed -i '' "s/YYYY-MM-DD/$today/g" "$file" 2>/dev/null || true
        else
            sed -i "s/\[Project Name\]/$PROJECT_NAME/g" "$file" 2>/dev/null || true
            sed -i "s/YYYY-MM-DD/$today/g" "$file" 2>/dev/null || true
        fi
    done
    
    print_success "Templates customized"
}

initialize_git() {
    if [[ "$INIT_GIT" == true ]]; then
        print_info "Initializing git repository..."
        
        cd "$TARGET_DIR"
        git init -q
        git add .
        git commit -q -m "chore: initial project setup from starter loop"
        
        print_success "Git initialized with initial commit"
        cd - > /dev/null
    fi
}

run_validation() {
    print_info "Validating setup..."
    
    if [[ -x "$SCRIPT_DIR/validate.sh" ]]; then
        "$SCRIPT_DIR/validate.sh" "$TARGET_DIR" 2>/dev/null || true
    fi
}

# =============================================================================
# Main
# =============================================================================

main() {
    print_header "Cursor Starter Loop - Project Setup"
    
    # Get project details
    prompt_project_name "$1"
    prompt_stack "$2"
    prompt_target_dir
    prompt_git_init
    
    # Check if target exists
    if [[ -d "$TARGET_DIR" ]]; then
        print_warning "Directory '$TARGET_DIR' already exists."
        read -p "Continue and merge? [y/N]: " overwrite
        case "$overwrite" in
            [yY]*) ;;
            *)     print_info "Aborted."; exit 0 ;;
        esac
    fi
    
    print_header "Creating Project: $PROJECT_NAME ($STACK)"
    
    # Scaffold
    create_directory_structure
    copy_core_templates
    copy_stack_templates
    replace_placeholders
    initialize_git
    
    # Summary
    print_header "Setup Complete!"
    
    echo "Project created at: $TARGET_DIR"
    echo ""
    echo "Next steps:"
    echo "  1. cd $TARGET_DIR"
    echo "  2. Fill in docs/PROJECT.md with project details"
    echo "  3. Review .cursor/rules/"
    echo "  4. Set up development environment"
    echo "  5. Run: cursor ."
    echo ""
    
    if [[ "$STACK" != "generic" ]]; then
        echo "Stack-specific setup ($STACK):"
        case "$STACK" in
            python)
                echo "  python -m venv venv"
                echo "  source venv/bin/activate"
                echo "  pip install -r requirements.txt"
                ;;
            node|nextjs)
                echo "  npm install"
                echo "  npm run dev"
                ;;
            laravel)
                echo "  composer install"
                echo "  php artisan key:generate"
                echo "  php artisan migrate"
                ;;
            swift)
                echo "  swift build"
                echo "  swift test"
                echo "  # Or open .xcodeproj in Xcode"
                ;;
        esac
        echo ""
    fi
    
    print_success "Happy coding!"
}

main "$@"
