---
title: "A BPMN cheat sheet"
date: 2025-09-01
slug: bpmn-fluxogramas
tags: [bpmn, fluxogramas, processos]
draft: false
---

For anyone starting to draw flowcharts, here are the BPMN event options.

Start begins the flow, intermediate happens along the way, boundary attaches to an activity to handle something, and end finishes the path. The rule of thumb: catch waits for something; throw triggers something.

---

## Start events

- **Start event, none:** starts without a condition.
- **Message start:** starts when a message arrives, such as a webhook.
- **Timer start:** schedule/cron, using a date, delay, or repetition.
- **Conditional start:** starts when an expression becomes true.
- **Signal start:** starts upon receiving a broadcast signal.

## Intermediate events

- **Message intermediate, throw:** sends a message to another participant.
- **Timer intermediate, catch:** waits for a time or date.
- **Escalation intermediate, throw:** raises an escalation without treating it as an error.
- **Conditional intermediate, catch:** pauses until a condition becomes true.
- **Link, catch/throw:** a jump within the same diagram, connecting points.
- **Compensation intermediate, throw:** triggers compensation to undo something.
- **Signal intermediate, catch/throw:** publish/subscribe broadcasting; any listener can receive it.

## Boundary events attached to a task or subprocess

- Trigger when something happens **during** the activity.
- **Interrupting, solid border:** cancels the activity and redirects the flow.
- **Non-interrupting, dashed border:** creates an alternative flow without cancelling the activity.

- Common types: **Timer, Message, Conditional, Signal, Escalation, Compensation**.

### Special cases

**Error boundary:** interrupting only; catches errors from the subprocess.

**Cancel boundary:** only on a **Transaction subprocess**.

- **Non-interrupting** variations keep the activity running.

## End events

- **Message end:** sends a message and ends.
- **Escalation end:** notifies the level above and ends.
- **Error end:** throws an error; leaves the subprocess until an *error boundary* catches it.
- **Cancel end:** cancels a **Transaction**.
- **Compensation end:** requests registered compensations.
- **Signal end:** emits a broadcast signal and ends.
- **Terminate end:** terminates **all** active activities in the process or subprocess.
