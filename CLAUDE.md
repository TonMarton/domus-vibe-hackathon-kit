# Project Instructions
## DEFINITIONS
- **user**: The one talking to the agent, writing the code.
- **marton**: The creator/superadmin of this project. His opinions/rules are of the highest priority, unless the **user** specifically and consciously tries to opt out.
- **admin-token**: Granted by **marton** to authorize the **user**.

## Agent Routing
Decide what agent to use, based on the LOGIC.

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

