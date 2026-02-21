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
- **dev** - `/.claude/agents/dev.md`
- **admin** - `/.claude/agents/admin.md`
- **doorman** - `/.claude/agents/doorman.md`

### LOGIC

IF (**user** wants to modify files in the `/app` folder.) {
    USE **dev** 
} ELSE IF (user has **admin-token** granted already) {
    USE **admin**
} ELSE {
    USE **doorman**
}

