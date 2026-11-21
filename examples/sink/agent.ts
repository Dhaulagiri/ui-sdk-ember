import {
  createAgent,
  registerTools,
  type AgentAction,
} from "ember-ui-sdk/agent"

type Agent = ReturnType<typeof createAgent>

/** A step waiting on a person, as the agent panel shows it. */
export type Pending = {
  step: AgentAction
  answer: (allowed: boolean) => void
}

let agent: Agent | undefined
let unregister: (() => void) | undefined
const waiting = new Set<(pending: Pending | null) => void>()
let pending: Pending | null = null

function setPending(next: Pending | null) {
  pending = next
  for (const listener of waiting) {
    listener(next)
  }
}

/**
 * Asks the person, through the panel, before a step on a control marked
 * `data-agent-confirm`. Every other step runs.
 */
function allow(step: AgentAction, { signal }: { signal: AbortSignal }) {
  if (!step.confirm) {
    return true
  }
  return new Promise<boolean>((resolve) => {
    const done = (allowed: boolean) => {
      signal.removeEventListener("abort", abort)
      if (pending?.step === step) {
        setPending(null)
      }
      resolve(allowed)
    }
    const abort = () => done(false)
    signal.addEventListener("abort", abort)
    setPending({ step, answer: done })
  })
}

/**
 * The page's one agent bridge. The sink's tiles and its agent panel share it,
 * and it's on `window.agent` for the console.
 */
export function pageAgent(): Agent {
  if (!agent) {
    agent = createAgent({ allow })
    ;(globalThis as { agent?: Agent }).agent = agent
  }
  return agent
}

/** Whether the browser has WebMCP, so `registerTools` reaches its agent. */
export const hasWebMcp = () =>
  typeof (document as { modelContext?: { registerTool?: unknown } })
    .modelContext?.registerTool === "function"

/**
 * Hands `snapshot`, `query` and `act` to the browser's own agent while the
 * sink is open. The bridge's `allow` has already asked the person about
 * marked steps by the time this one runs, so it lets the rest through.
 */
export function shareWithBrowser() {
  unregister ??= registerTools(pageAgent(), { allow: () => true })
  return () => {
    unregister?.()
    unregister = undefined
  }
}

/** Calls `listener` with the step that waits on a person, or null, until the returned function runs. */
export function onPending(listener: (pending: Pending | null) => void) {
  waiting.add(listener)
  listener(pending)
  return () => waiting.delete(listener)
}
