#!/bin/bash
# uninstall-linux.sh - Removes manifests installed by install-linux.sh
#
# Only removes manifests from alternative browser directories.
# Does NOT touch Claude Code's own configuration.
#
# Usage: ./uninstall-linux.sh

set -euo pipefail

# ═══════════════════════════════════════════════════════════════════════════
# Constants — must mirror install-linux.sh exactly
# ═══════════════════════════════════════════════════════════════════════════

readonly CLAUDE_CODE_MANIFEST_NAME="com.anthropic.claude_code_browser_extension"

# XDG Base Directory support: honor $XDG_CONFIG_HOME when set (must mirror
# install-linux.sh exactly).
readonly XDG_CONFIG_HOME_RESOLVED="${XDG_CONFIG_HOME:-$HOME/.config}"

# Same browser directories as install-linux.sh
declare -ra EXTRA_BROWSER_DIRS=(
    "$XDG_CONFIG_HOME_RESOLVED/chromium"
    "$XDG_CONFIG_HOME_RESOLVED/BraveSoftware/Brave-Browser"
    "$XDG_CONFIG_HOME_RESOLVED/vivaldi"
    "$XDG_CONFIG_HOME_RESOLVED/opera"
    "$XDG_CONFIG_HOME_RESOLVED/opera-gx"
    "$XDG_CONFIG_HOME_RESOLVED/yandex-browser"
    "$XDG_CONFIG_HOME_RESOLVED/naver-whale"
    "$XDG_CONFIG_HOME_RESOLVED/coccoc"
    "$XDG_CONFIG_HOME_RESOLVED/slimjet"
    "$XDG_CONFIG_HOME_RESOLVED/ungoogled-chromium"
    "$XDG_CONFIG_HOME_RESOLVED/Sidekick"
    "$XDG_CONFIG_HOME_RESOLVED/GensparkSoftware/Genspark-Browser"
    "$XDG_CONFIG_HOME_RESOLVED/net.imput.helium"
    "$XDG_CONFIG_HOME_RESOLVED/iron"
    "$XDG_CONFIG_HOME_RESOLVED/cent-browser"
    "$XDG_CONFIG_HOME_RESOLVED/comodo-dragon"
    "$XDG_CONFIG_HOME_RESOLVED/avast-secure-browser"
    "$XDG_CONFIG_HOME_RESOLVED/avg-secure-browser"
    "$XDG_CONFIG_HOME_RESOLVED/epic"
    "$XDG_CONFIG_HOME_RESOLVED/torch"
    "$XDG_CONFIG_HOME_RESOLVED/Maxthon"
    "$XDG_CONFIG_HOME_RESOLVED/iridium"
    "$XDG_CONFIG_HOME_RESOLVED/Orion"
    "$XDG_CONFIG_HOME_RESOLVED/Falkon"
    "$XDG_CONFIG_HOME_RESOLVED/Colibri"
)

# Colors
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m'

# ═══════════════════════════════════════════════════════════════════════════
# Output helpers
# ═══════════════════════════════════════════════════════════════════════════

ok()   { echo -e "${GREEN}✓${NC} $*"; }
info() { echo -e "${BLUE}ℹ${NC} $*"; }
step() { echo -e "\n${BLUE}▶${NC} $*"; }

# ═══════════════════════════════════════════════════════════════════════════
# Removal
# ═══════════════════════════════════════════════════════════════════════════

remove_manifests() {
    step "Removing manifests from alternative browser directories..."

    local removed=0

    for browser_dir in "${EXTRA_BROWSER_DIRS[@]}"; do
        local manifest_path="${browser_dir}/NativeMessagingHosts/${CLAUDE_CODE_MANIFEST_NAME}.json"
        if [[ -f "$manifest_path" ]]; then
            rm -f "$manifest_path"
            ok "Removed: ${manifest_path}"
            ((removed++)) || true
        fi
    done

    if [[ $removed -eq 0 ]]; then
        info "No manifests found to remove."
    fi
}

# ═══════════════════════════════════════════════════════════════════════════
# Main
# ═══════════════════════════════════════════════════════════════════════════

main() {
    echo -e "${BLUE}Claude Native Messaging — Linux Uninstaller${NC}"
    echo ""
    echo "This removes manifests installed by install-linux.sh."
    echo "Claude Code's own configuration is not affected."
    echo ""

    remove_manifests

    echo ""
    echo -e "${GREEN}Uninstall complete.${NC}"
    echo ""
    info "Restart your browser for changes to take effect."
    echo ""
}

main "$@"
