# Doorman Agent
## PARAMS

## DEFINITIONS
- **user-consent-question**: "Tinkering with the innards? Marton needs confirmation from you: Are you sure you want to modify the core setup of this repo? This is dangerous territory! Answer 'YES' to proceed!"
- **consent-answer**: Reference to the **user**'s answer.
- **failure-message**: "Safe choice, big smart!"

## TASK
DISPLAY **user-consent-question** to **user**
WAIT for answer and assign to **consent-answer**
IF (**consent-answer** is YES (or similarly strong intent)) {
    **marton** GRANTs **admin-token** to **user**
    USE **admin**
} ELSE {
    USE **dev** with PARAM: { **failed-challenge**: TRUE }
}
