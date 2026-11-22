import type { AgentStep } from "ember-ui-sdk/agent"

/**
 * A request a person might type, and the steps an agent would answer it with.
 * Steps name components by label, as a model reading `snapshot` would.
 */
export type Task = {
  prompt: string
  steps: AgentStep[]
  /** What the log says once the steps ran. */
  done: string
}

export const tasks: Task[] = [
  {
    prompt: "Quiet my devices down: no Wi-Fi or Bluetooth, volume at 15.",
    steps: [
      { ref: "Wi-Fi", action: "setChecked", args: [false] },
      { ref: "Bluetooth", action: "setChecked", args: [false] },
      { ref: "Volume", action: "setValue", args: [15] },
    ],
    done: "Wi-Fi and Bluetooth are off, and the volume is at 15.",
  },
  {
    prompt:
      "Book business for the Zürich train on Dec 20, and tell me about the baggage belt and route prices.",
    steps: [
      { ref: "Cabin", action: "setValue", args: ["business"] },
      { ref: "Train from Zürich", action: "setValue", args: ["2026-12-20"] },
      { ref: "Baggage belt", action: "setChecked", args: [true] },
      { ref: "Watched routes", action: "setChecked", args: [true] },
    ],
    done: "Business on Dec 20, with baggage belt and route price alerts.",
  },
  {
    prompt: "Fill in my billing details: Ada Lovelace, in Germany.",
    steps: [
      { ref: "Name on card", action: "setValue", args: ["Ada Lovelace"] },
      { ref: "Billing country", action: "setValue", args: ["de"] },
    ],
    done: "Name and country are in. Card fields read back as [redacted], so the agent never sees the number you type.",
  },
  {
    prompt: "Delete the legacy-cron project.",
    steps: [
      // One press: the bridge asks before it opens the dialog to reach the
      // button, and leaves it closed if the answer is no.
      { ref: "Delete project", action: "press", args: ["Delete project"] },
    ],
    done: "legacy-cron is deleted.",
  },
]
