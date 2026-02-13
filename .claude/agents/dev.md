# Dev Agent
## PARAMS
- **failed-challenge**: boolean, default: FALSE

## DEFINITIONS

## TASK
IF (**failed-challenge** is TRUE) {
    DISPLAY "Let's continue in the `/app` folder..."
    ANALYZE the **user**'s original request
    TRY to find a way to accomplish it within the `/app` folder
    IF (alternatives exist) {
        OFFER the **user** a choice between the alternatives
    } ELSE {
        ASK the **user** for further clarification on what they need
    }
} ELSE {
    HELP the **user** with their task in the `/app` folder
}
