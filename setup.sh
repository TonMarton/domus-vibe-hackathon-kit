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
    *)       error "Unsupported OS: $(uname -s)"; exit 1 ;;
  esac
  info "Detected OS: $OS"
}

# --- Homebrew (macOS) ---
install_homebrew() {
  if [ "$OS" = "macos" ]; then
    if ! command -v brew &>/dev/null; then
      info "Installing Homebrew..."
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      if [ -f /opt/homebrew/bin/brew ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
      fi
      success "Homebrew installed"
    else
      success "Homebrew already installed"
    fi
  fi
}

# --- Git ---
install_git() {
  if ! command -v git &>/dev/null; then
    info "Installing git..."
    if [ "$OS" = "macos" ]; then
      brew install git
    else
      sudo apt-get update && sudo apt-get install -y git
    fi
    success "git installed"
  else
    success "git already installed ($(git --version))"
  fi
}

# --- Docker ---
install_docker() {
  if ! command -v docker &>/dev/null; then
    if [ "$OS" = "macos" ]; then
      info "Installing Docker Desktop via Homebrew..."
      brew install --cask docker
      info "Docker Desktop installed. Please open it from Applications to complete setup."
      info "After Docker Desktop is running, re-run this script."
      exit 0
    else
      warn "Docker is not installed."
      info "Install Docker Engine: https://docs.docker.com/engine/install/"
      info "After installing, run this script again."
      exit 1
    fi
  fi

  if ! docker info &>/dev/null; then
    error "Docker is installed but not running. Please start Docker Desktop and re-run."
    exit 1
  fi
  success "Docker is running"
}

# --- nvm ---
install_nvm() {
  export NVM_DIR="$HOME/.nvm"

  if [ ! -s "$NVM_DIR/nvm.sh" ]; then
    info "Installing nvm..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
    success "nvm installed"
  else
    success "nvm already installed"
  fi

  # Source nvm for this script session
  \. "$NVM_DIR/nvm.sh"
}

# --- Node + pnpm via nvm + corepack ---
install_node_pnpm() {
  info "Installing Node.js via nvm..."
  nvm install
  success "Node.js $(node --version) installed"

  info "Enabling corepack for pnpm..."
  corepack enable
  corepack prepare --activate
  success "pnpm $(pnpm --version) installed"
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

# --- Dependencies ---
install_dependencies() {
  info "Installing dependencies..."
  pnpm install
  success "Dependencies installed"
}

# --- Database ---
start_database() {
  info "Starting PostgreSQL..."
  docker compose up -d postgres

  info "Waiting for database to be ready..."
  local retries=30
  while [ $retries -gt 0 ]; do
    if docker compose exec postgres pg_isready -U domus &>/dev/null; then
      success "PostgreSQL is ready"
      return
    fi
    retries=$((retries - 1))
    sleep 1
  done
  error "PostgreSQL failed to start within 30 seconds"
  exit 1
}

# --- Migrations ---
run_migrations() {
  if [ -f "app/package.json" ]; then
    info "Pushing database schema..."
    pnpm db:push
    success "Database schema pushed"
  else
    warn "Skipping migrations (no app scaffolded yet)"
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
  install_homebrew
  install_git
  install_docker
  install_nvm
  install_node_pnpm
  setup_env
  install_dependencies
  start_database
  run_migrations

  echo ""
  echo "========================================="
  success "Setup complete!"
  echo "========================================="
  echo ""
  info "Next steps:"
  echo "  1. Run 'pnpm dev' to start the dev server"
  echo "  2. Open http://localhost:3000"
  echo "  3. Start building!"
  echo ""
  info "Useful commands:"
  echo "  pnpm dev        - Start dev server + database"
  echo "  pnpm build      - Production build"
  echo "  pnpm db:studio  - Open Drizzle Studio (database GUI)"
  echo "  pnpm lint       - Check code style"
  echo "  pnpm lint:fix   - Auto-fix code style"
  echo ""
}

main "$@"
