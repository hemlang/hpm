#!/bin/sh
# HPM - Hemlock Package Manager
# One-line installer script
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/hemlang/hpm/main/install.sh | sh
#
# Or with custom install directory:
#   curl -fsSL https://raw.githubusercontent.com/hemlang/hpm/main/install.sh | sh -s -- --prefix ~/.local
#
# Options:
#   --prefix DIR    Install to DIR/bin (default: /usr/local)
#   --version VER   Install specific version (default: latest)
#   --help          Show this help message

set -e

REPO="hemlang/hpm"
PREFIX="/usr/local"
VERSION=""

# Colors (disabled if not a terminal)
if [ -t 1 ]; then
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[0;33m'
    BLUE='\033[0;34m'
    BOLD='\033[1m'
    NC='\033[0m'
else
    RED=''
    GREEN=''
    YELLOW=''
    BLUE=''
    BOLD=''
    NC=''
fi

info() {
    printf "${BLUE}==>${NC} ${BOLD}%s${NC}\n" "$1"
}

success() {
    printf "${GREEN}==>${NC} ${BOLD}%s${NC}\n" "$1"
}

warn() {
    printf "${YELLOW}Warning:${NC} %s\n" "$1"
}

error() {
    printf "${RED}Error:${NC} %s\n" "$1" >&2
    exit 1
}

usage() {
    cat << EOF
HPM Installer

Usage:
    curl -fsSL https://raw.githubusercontent.com/hemlang/hpm/main/install.sh | sh

Options:
    --prefix DIR    Install to DIR/bin (default: /usr/local)
    --version VER   Install specific version (default: latest)
    --help          Show this help message

Examples:
    # Install latest version to /usr/local/bin
    curl -fsSL https://raw.githubusercontent.com/hemlang/hpm/main/install.sh | sh

    # Install to ~/.local/bin
    curl -fsSL https://raw.githubusercontent.com/hemlang/hpm/main/install.sh | sh -s -- --prefix ~/.local

    # Install specific version
    curl -fsSL https://raw.githubusercontent.com/hemlang/hpm/main/install.sh | sh -s -- --version 1.0.5
EOF
    exit 0
}

# Parse arguments
while [ $# -gt 0 ]; do
    case "$1" in
        --prefix)
            PREFIX="$2"
            shift 2
            ;;
        --prefix=*)
            PREFIX="${1#*=}"
            shift
            ;;
        --version)
            VERSION="$2"
            shift 2
            ;;
        --version=*)
            VERSION="${1#*=}"
            shift
            ;;
        --help|-h)
            usage
            ;;
        *)
            error "Unknown option: $1"
            ;;
    esac
done

# Detect OS
detect_os() {
    case "$(uname -s)" in
        Linux*)  echo "linux" ;;
        Darwin*) echo "darwin" ;;
        *)       error "Unsupported operating system: $(uname -s)" ;;
    esac
}

# Detect architecture
detect_arch() {
    case "$(uname -m)" in
        x86_64|amd64)  echo "x86_64" ;;
        arm64|aarch64) echo "arm64" ;;
        *)             error "Unsupported architecture: $(uname -m)" ;;
    esac
}

# Check for required commands
check_requirements() {
    for cmd in curl tar; do
        if ! command -v "$cmd" >/dev/null 2>&1; then
            error "Required command not found: $cmd"
        fi
    done
}

# Get latest version from GitHub
get_latest_version() {
    curl -fsSL "https://api.github.com/repos/${REPO}/releases/latest" | \
        grep '"tag_name"' | \
        sed -E 's/.*"tag_name": *"v?([^"]+)".*/\1/'
}

# Main installation
main() {
    info "HPM Installer"
    echo ""

    check_requirements

    OS=$(detect_os)
    ARCH=$(detect_arch)

    # Handle darwin arm64 -> arm64, darwin x86_64 -> x86_64
    # Linux only has x86_64 currently
    if [ "$OS" = "linux" ] && [ "$ARCH" = "arm64" ]; then
        error "Linux ARM64 is not currently supported. Please build from source."
    fi

    info "Detected platform: ${OS}-${ARCH}"

    # Get version
    if [ -z "$VERSION" ]; then
        info "Fetching latest version..."
        VERSION=$(get_latest_version)
        if [ -z "$VERSION" ]; then
            error "Failed to determine latest version"
        fi
    fi

    info "Installing hpm v${VERSION}"

    # Build download URL
    PACKAGE_NAME="hpm-${VERSION}-${OS}-${ARCH}"
    DOWNLOAD_URL="https://github.com/${REPO}/releases/download/v${VERSION}/${PACKAGE_NAME}.tar.gz"

    # Create temp directory
    TMPDIR=$(mktemp -d)
    trap 'rm -rf "$TMPDIR"' EXIT

    info "Downloading ${PACKAGE_NAME}.tar.gz..."
    if ! curl -fsSL "$DOWNLOAD_URL" -o "$TMPDIR/hpm.tar.gz"; then
        error "Failed to download hpm. Check that version ${VERSION} exists for ${OS}-${ARCH}"
    fi

    info "Extracting..."
    tar -xzf "$TMPDIR/hpm.tar.gz" -C "$TMPDIR"

    # Find the binary
    BINARY_PATH="$TMPDIR/${PACKAGE_NAME}/bin/hpm"
    if [ ! -f "$BINARY_PATH" ]; then
        error "Binary not found in archive"
    fi

    # Install
    INSTALL_DIR="${PREFIX}/bin"
    info "Installing to ${INSTALL_DIR}..."

    mkdir -p "$INSTALL_DIR"

    if [ -w "$INSTALL_DIR" ]; then
        cp "$BINARY_PATH" "$INSTALL_DIR/hpm"
        chmod +x "$INSTALL_DIR/hpm"
    else
        warn "Elevated permissions required for ${INSTALL_DIR}"
        sudo cp "$BINARY_PATH" "$INSTALL_DIR/hpm"
        sudo chmod +x "$INSTALL_DIR/hpm"
    fi

    echo ""
    success "hpm v${VERSION} installed successfully!"
    echo ""

    # Check if in PATH
    if command -v hpm >/dev/null 2>&1; then
        echo "  Run 'hpm --help' to get started"
    else
        echo "  Add ${INSTALL_DIR} to your PATH:"
        echo ""
        echo "    export PATH=\"${INSTALL_DIR}:\$PATH\""
        echo ""
        echo "  Then run 'hpm --help' to get started"
    fi
}

main "$@"
