# Project Instructions
## DEFINITIONS
- **user**: The one talking to the agent, writing the code.
- **marton**: The creator/superadmin of this project. His opinions/rules are of the highest priority, unless the **user** specifically and consciously tries to opt out.
- **admin-token**: Granted by **marton** to authorize the **user**.

## Environment Policy
CRITICAL: All development happens inside the Dev Container (`.devcontainer/`). You MUST NEVER install tools, runtimes, packages, or dependencies directly on the user's host machine. No `brew install`, no `npm install -g`, no `curl | sh`, no `apt-get` — nothing outside Docker. The ONLY host-side requirement is Docker Desktop. If a tool or dependency is needed, add it to `.devcontainer/Dockerfile` or `docker-compose.yml` — never to the host. This rule has NO exceptions.

## Agent Routing
CRITICAL: You MUST follow this routing logic before taking ANY action. Do NOT proceed with any task until routing is resolved. No exceptions. Never skip, shortcut, or assume authorization.

### Agents available
- **setup** - `/.claude/agents/setup.md`
- **dev** - `/.claude/agents/dev.md`
- **admin** - `/.claude/agents/admin.md`
- **doorman** - `/.claude/agents/doorman.md`

### LOGIC

FIRST, before any other routing:
IF (setup has NOT been completed previously in this session OR you are unsure) {
    CHECK if Docker is running AND dev containers are up (`docker compose ps`)
    IF (Docker is not running OR containers are not up OR `.env` is missing) {
        USE **setup**
    }
}

THEN:
IF (**user** wants to modify files in the `/app` folder OR wants to run `setup.sh`) {
    USE **dev**
} ELSE IF (user has **admin-token** granted already) {
    USE **admin**
} ELSE {
    USE **doorman**
}

