#!/bin/bash

# install.sh - Install add-mcps system to ~/.add-mcps/
# This script sets up the add-mcps system in the user's home directory
# so it can be used from any project directory

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Get script directory (where install.sh is located)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
INSTALL_DIR="$HOME/.add-mcps"

log_info "Installing add-mcps system to $INSTALL_DIR..."
echo ""

# Create install directory
mkdir -p "$INSTALL_DIR"
mkdir -p "$INSTALL_DIR/agents"

# Copy CLAUDE.md
if [[ -f "$SCRIPT_DIR/CLAUDE.md" ]]; then
    cp "$SCRIPT_DIR/CLAUDE.md" "$INSTALL_DIR/CLAUDE.md"
    log_success "Copied CLAUDE.md"
else
    log_warning "CLAUDE.md not found in $SCRIPT_DIR"
fi

# Copy AGENTS.md
if [[ -f "$SCRIPT_DIR/AGENTS.md" ]]; then
    cp "$SCRIPT_DIR/AGENTS.md" "$INSTALL_DIR/AGENTS.md"
    log_success "Copied AGENTS.md"
else
    log_warning "AGENTS.md not found in $SCRIPT_DIR"
fi

# Copy agent files
if [[ -d "$SCRIPT_DIR/.claude/agents" ]]; then
    copied=0
    for agent_file in "$SCRIPT_DIR/.claude/agents"/*.md; do
        if [[ -f "$agent_file" ]]; then
            cp "$agent_file" "$INSTALL_DIR/agents/"
            ((copied++))
        fi
    done
    if [[ $copied -gt 0 ]]; then
        log_success "Copied $copied agent file(s)"
    fi
else
    log_warning "Agents directory not found in $SCRIPT_DIR/.claude/agents"
fi

# Copy add-mcps script
if [[ -f "$SCRIPT_DIR/add-mcps" ]]; then
    cp "$SCRIPT_DIR/add-mcps" "$INSTALL_DIR/add-mcps"
    chmod +x "$INSTALL_DIR/add-mcps"
    log_success "Copied add-mcps script"
else
    log_warning "add-mcps script not found in $SCRIPT_DIR"
fi

# Function to check if directory is in PATH
is_in_path() {
    local dir="$1"
    case ":$PATH:" in
        *:"$dir":*) return 0 ;;
        *) return 1 ;;
    esac
}

# Function to detect shell config file
detect_shell_config() {
    local shell_name=$(basename "$SHELL" 2>/dev/null || echo "bash")
    
    case "$shell_name" in
        zsh)
            if [[ -f "$HOME/.zshrc" ]]; then
                echo "$HOME/.zshrc"
            elif [[ -f "$HOME/.zprofile" ]]; then
                echo "$HOME/.zprofile"
            else
                echo "$HOME/.zshrc"
            fi
            ;;
        bash)
            if [[ -f "$HOME/.bashrc" ]]; then
                echo "$HOME/.bashrc"
            elif [[ -f "$HOME/.bash_profile" ]]; then
                echo "$HOME/.bash_profile"
            else
                echo "$HOME/.bashrc"
            fi
            ;;
        *)
            # Default to .bashrc, fallback to .profile
            if [[ -f "$HOME/.bashrc" ]]; then
                echo "$HOME/.bashrc"
            elif [[ -f "$HOME/.profile" ]]; then
                echo "$HOME/.profile"
            else
                echo "$HOME/.bashrc"
            fi
            ;;
    esac
}

# Check if already in PATH
echo ""
log_info "Checking PATH configuration..."

if is_in_path "$INSTALL_DIR"; then
    log_success "$INSTALL_DIR is already in PATH"
else
    log_info "$INSTALL_DIR is not in PATH, adding it..."
    
    # Detect shell config file
    SHELL_CONFIG=$(detect_shell_config)
    PATH_EXPORT="export PATH=\"\$HOME/.add-mcps:\$PATH\""
    
    # Check if already added to config file (check for .add-mcps or INSTALL_DIR)
    if [[ -f "$SHELL_CONFIG" ]] && (grep -qF ".add-mcps" "$SHELL_CONFIG" 2>/dev/null || grep -qF "$INSTALL_DIR" "$SHELL_CONFIG" 2>/dev/null); then
        log_info "PATH entry already exists in $SHELL_CONFIG"
        log_info "To use 'add-mcps' immediately, run: source $SHELL_CONFIG"
        log_info "Or start a new terminal session"
    else
        # Add to shell config
        if [[ -f "$SHELL_CONFIG" ]]; then
            echo "" >> "$SHELL_CONFIG"
            echo "# Added by add-mcps install.sh" >> "$SHELL_CONFIG"
            echo "$PATH_EXPORT" >> "$SHELL_CONFIG"
            log_success "Added PATH entry to $SHELL_CONFIG"
        else
            # Create new config file
            echo "$PATH_EXPORT" > "$SHELL_CONFIG"
            log_success "Created $SHELL_CONFIG with PATH entry"
        fi
        
        log_info "To use 'add-mcps' immediately, run: source $SHELL_CONFIG"
        log_info "Or start a new terminal session"
    fi
fi

echo ""
log_success "Installation complete!"
echo ""
log_info "Installation directory: $INSTALL_DIR"
echo ""
if ! is_in_path "$INSTALL_DIR"; then
    log_info "Next steps:"
    echo "  1. Run: source $SHELL_CONFIG"
    echo "     Or start a new terminal session"
    echo "  2. Run 'add-mcps' from any project directory"
    echo ""
else
    log_info "You can now run 'add-mcps' from any project directory"
    echo ""
fi

