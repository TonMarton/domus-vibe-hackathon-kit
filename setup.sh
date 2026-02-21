#!/usr/bin/env bash
set -euo pipefail

# --- Colors ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info()    { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }
warn()    { echo -e "${YELLOW}[WARN]${NC} $1"; }
error()   { echo -e "${RED}[ERROR]${NC} $1"; }

# --- OS Detection ---
detect_os() {
  case "$(uname -s)" in
    Darwin*) OS="macos" ;;
    Linux*)  OS="linux" ;;
    MINGW*|MSYS*|CYGWIN*) OS="windows" ;;
    *)       error "Unsupported OS: $(uname -s)"; exit 1 ;;
  esac
  info "Detected OS: $OS"
}

# --- Docker ---
ensure_docker() {
  if ! command -v docker &>/dev/null; then
    if [ "$OS" = "macos" ]; then
      if command -v brew &>/dev/null; then
        info "Installing Docker Desktop via Homebrew..."
        brew install --cask docker
      else
        info "Install Docker Desktop: https://docs.docker.com/desktop/setup/install/mac-install/"
      fi
      info "Open Docker Desktop from Applications, then re-run this script."
      exit 0
    else
      info "Install Docker Desktop: https://docs.docker.com/desktop/install/"
      info "After installing, re-run this script."
      exit 1
    fi
  fi

  if ! docker info &>/dev/null; then
    error "Docker is installed but not running. Start Docker Desktop and re-run."
    exit 1
  fi
  success "Docker is running"
}

# --- Environment file ---
setup_env() {
  if [ ! -f ".env" ]; then
    info "Creating .env from .env.example..."
    cp .env.example .env
    success ".env created"
  else
    success ".env already exists"
  fi
}

# --- Main ---
main() {
  echo ""
  echo "========================================="
  echo "  Domus Hackathon Kit - Setup"
  echo "========================================="
  echo ""

  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  cd "$SCRIPT_DIR"

  detect_os
  ensure_docker
  setup_env

  echo ""
  echo "========================================="
  success "Ready to go!"
  echo "========================================="
  echo ""
  info "Next steps:"
  echo "  1. Open this folder in VS Code / Cursor"
  echo "  2. Install the 'Dev Containers' extension (if not installed)"
  echo "  3. Press Cmd+Shift+P → 'Dev Containers: Reopen in Container'"
  echo "  4. Wait for the container to build (first time takes ~1 min)"
  echo "  5. Run 'pnpm dev' and open http://localhost:3000"
  echo ""
}

main "$@"
