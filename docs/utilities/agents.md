---
title: Agents
description: Let an AI agent read your components and use them, here or through the browser's own agent.
---

`ember-ui-sdk/agent` connects an AI agent to the components on the page. The agent can read their state, find the actions they support, and call those actions through each component's API, the same way a person's clicks and keys do. It's `@ui-sdk/core`'s agent bridge, so it works the same as in [the other frameworks](https://ui-sdk.dev/docs/agents/connect-an-agent).

[agent/basic](../../examples/components/agent/ember/basic.gts)

Choose Snapshot to see what an agent sees, then let the agent change both controls. The log shows each change with its source.

## Create the Bridge

Create the bridge once, before the components you want it to see render. It hears components as they're made:

```ts
import { createAgent } from "ember-ui-sdk/agent"

export const agent = createAgent()
```

Give each component an accessible name, from a `Field` label, a `<label>` or `aria-label`. People using a screen reader and agents find it by that name.

## Read and Act

The bridge has three methods. They're also its tools, with the same names and input:

- `snapshot()` lists the components with their state and the actions they take now, like `setValue` or `press`.
- `query({ text, within, kind, closed, from })` finds components by label, or the items of one list, without listing the page. With `closed: true` it also reads what the other tabs and the closed sections hold.
- `act({ steps })` runs steps in order and reports what changed. A step names a component by its ref or its label, and finds it behind a closed tab or section too.

```ts
agent.snapshot()
// [{ ref: "c1", component: "select", label: "Region", value: "europe", actions: ["setOpen", "setValue", ...] }]

await agent.act({
  steps: [
    { ref: "Region", action: "setValue", args: ["Asia Pacific"] },
    { ref: "Preview deployments", action: "setChecked", args: [true] },
  ],
})
```

Every change an agent makes reaches the component's `@on<Key>Change` with the source `"agent"`, so your app can tell it from a person's. `agent.subscribe` reports every change, from either.

## Give It to a Model

`agentTools` is the three tools as JSON Schema, the shape model APIs take. Pass them as tools, and answer each tool call with the method of the same name:

```ts
import { agentTools } from "ember-ui-sdk/agent"

const result = await agent[call.name](call.input)
```

## Choose What It Can Do

`allow` runs before every step, and can refuse it or ask the person first:

```ts
const agent = createAgent({
  allow: (step) => (step.confirm ? askThePerson(step.confirm) : true),
})
```

Mark the page where it needs a person or must stay private:

- `data-agent-confirm="Deletes the project"` on a control makes a step on it wait for the person. `allow` gets the sentence as `step.confirm`. Without `allow`, the step fails and leaves the change to them.
- `data-agent-secret` reads the values inside it as `"[redacted]"`. Password, card and one-time-code fields already do.
- `data-agent-hidden` keeps the components inside it out of the agent's view.

If you ask the person with a dialog of your own, make it an [AlertDialog](../components/alert-dialog.md), so it opens over any dialog the agent opened, and put `data-agent-hidden` on its content so the agent can't answer itself.

## Share It With the Browser

`registerTools` hands the three tools to the browser's own agent through WebMCP, `document.modelContext`. In a browser without it, it does nothing. You didn't write that agent, so it takes an `allow` of its own, which runs after the bridge's:

```ts
import { registerTools } from "ember-ui-sdk/agent"

const unregister = registerTools(agent, {
  allow: (step) => step.action !== "press" || confirm(`Press ${step.args[0]}?`),
})
```

Call `unregister` when the page no longer wants it, like in a component's destructor.

## In the Sink

The [sink](#/sink) runs all of this across its tiles. Open **Agent** in its corner to run requests an agent would answer, call the three tools from a console, and watch every change with its source. The bridge is on `window.agent` there, and in a browser with WebMCP its agent gets the same tools.
