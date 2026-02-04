#!/usr/bin/env bash

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored messages
info() { echo -e "${GREEN}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Detect OS and set config paths
detect_config_paths() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        VSCODE_CONFIG="$HOME/Library/Application Support/Code/User"
        CURSOR_CONFIG="$HOME/Library/Application Support/Cursor/User"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        VSCODE_CONFIG="$HOME/.config/Code/User"
        CURSOR_CONFIG="$HOME/.config/Cursor/User"
    else
        error "Unsupported OS: $OSTYPE"
        exit 1
    fi
}

# Check if jq is installed
check_jq() {
    if ! command -v jq &> /dev/null; then
        error "jq is not installed. Please install it first:"
        echo "  macOS: brew install jq"
        echo "  Linux: sudo apt-get install jq or sudo yum install jq"
        exit 1
    fi
}

# Function to merge JSON settings
merge_settings() {
    local source_file="$1"
    local target_file="$2"
    local backup_file="${target_file}.backup.$(date +%Y%m%d_%H%M%S)"
    
    # Create backup
    if [[ -f "$target_file" ]]; then
        info "Creating backup: $backup_file"
        cp "$target_file" "$backup_file"
    else
        info "No existing settings file, creating new one"
        echo '{}' > "$target_file"
    fi
    
    # Merge settings using jq
    info "Merging settings from $source_file to $target_file"
    jq -s '.[0] * .[1]' "$target_file" "$source_file" > "${target_file}.tmp"
    mv "${target_file}.tmp" "$target_file"
}

# Function to merge keybindings (array)
merge_keybindings() {
    local source_file="$1"
    local target_file="$2"
    local backup_file="${target_file}.backup.$(date +%Y%m%d_%H%M%S)"
    
    # Create backup
    if [[ -f "$target_file" ]]; then
        info "Creating backup: $backup_file"
        cp "$target_file" "$backup_file"
    else
        info "No existing keybindings file, creating new one"
        echo '[]' > "$target_file"
    fi
    
    # Get the keybindings we want to add
    local new_keybindings=$(cat "$source_file")
    
    # Remove any existing conflicting keybindings and add new ones
    info "Merging keybindings from $source_file to $target_file"
    jq --argjson new "$new_keybindings" '
        # Remove existing keybindings that conflict with our new ones
        map(select(
            .key != "tab" or 
            (.command != "-editor.action.inlineSuggest.commit" and 
             .command != "selectNextSuggestion")
        )) |
        map(select(
            .key != "shift+tab" or 
            .command != "selectPrevSuggestion"
        )) |
        map(select(
            .key != "enter" or 
            (.command != "acceptSelectedSuggestion" and 
             .command != "type")
        )) |
        map(select(
            .key != "`" or 
            .command != "editor.action.inlineSuggest.commit"
        )) |
        # Add new keybindings
        . + $new
    ' "$target_file" > "${target_file}.tmp"
    mv "${target_file}.tmp" "$target_file"
}

# Main installation function
install_config() {
    local editor="$1"
    local config_dir="$2"
    
    info "Installing configuration for $editor"
    
    # Check if editor config directory exists
    if [[ ! -d "$config_dir" ]]; then
        warn "$editor config directory not found: $config_dir"
        warn "Skipping $editor installation"
        return
    fi
    
    # Find the source files
    local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    local settings_source="${SETTINGS_FILE:-$script_dir/vscode-vim-settings.json}"
    local keybindings_source="${KEYBINDINGS_FILE:-$script_dir/vscode-vim-keybinds.json}"
    
    if [[ ! -f "$settings_source" ]]; then
        error "Settings file not found: $settings_source"
        exit 1
    fi
    
    if [[ ! -f "$keybindings_source" ]]; then
        error "Keybindings file not found: $keybindings_source"
        exit 1
    fi
    
    # Merge settings
    merge_settings "$settings_source" "$config_dir/settings.json"
    
    # Merge keybindings
    merge_keybindings "$keybindings_source" "$config_dir/keybindings.json"
    
    info "$editor configuration installed successfully!"
}

# Parse command line arguments
INSTALL_VSCODE=true
INSTALL_CURSOR=true
SETTINGS_FILE=""
KEYBINDINGS_FILE=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --vscode-only)
            INSTALL_CURSOR=false
            shift
            ;;
        --cursor-only)
            INSTALL_VSCODE=false
            shift
            ;;
        --settings)
            SETTINGS_FILE="$2"
            shift 2
            ;;
        --keybindings)
            KEYBINDINGS_FILE="$2"
            shift 2
            ;;
        -h|--help)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --vscode-only        Install only for VSCode"
            echo "  --cursor-only        Install only for Cursor"
            echo "  --settings FILE      Path to settings JSON file"
            echo "  --keybindings FILE   Path to keybindings JSON file"
            echo "  -h, --help          Show this help message"
            echo ""
            echo "By default, installs to both VSCode and Cursor if they exist."
            exit 0
            ;;
        *)
            error "Unknown option: $1"
            echo "Use -h or --help for usage information"
            exit 1
            ;;
    esac
done

# Main execution
info "Starting Vim configuration installation for VSCode/Cursor"

check_jq
detect_config_paths

if [[ "$INSTALL_VSCODE" == true ]]; then
    install_config "VSCode" "$VSCODE_CONFIG"
fi

if [[ "$INSTALL_CURSOR" == true ]]; then
    install_config "Cursor" "$CURSOR_CONFIG"
fi

info "Installation complete!"
info "Please restart VSCode/Cursor for changes to take effect."
