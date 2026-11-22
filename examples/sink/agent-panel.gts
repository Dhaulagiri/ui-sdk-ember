import { isDestroying, registerDestructor } from "@ember/destroyable"
import { fn } from "@ember/helper"
import { on } from "@ember/modifier"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Bot, Check, Play, X } from "lucide"
import type { ObservedChange } from "ember-ui-sdk/agent"
import { AlertDialog } from "ember-ui-sdk/alert-dialog"
import { elementOf } from "ember-ui-sdk/observe"
import { SegmentedControl } from "ember-ui-sdk/segmented-control"
import { Tabs } from "ember-ui-sdk/tabs"
import {
  hasWebMcp,
  onPending,
  pageAgent,
  shareWithBrowser,
  type Pending,
} from "./agent.ts"
import { icon } from "./icon.ts"
import { tasks, type Task } from "./tasks.ts"

type Tool = "snapshot" | "query" | "act"

type Line = {
  kind: "task" | "call" | "seen" | "done" | "error" | "ask"
  text: string
}

type Change = ObservedChange & { at: number }

const examples: Record<Tool, string> = {
  snapshot: "",
  query: JSON.stringify({ within: "Cabin" }, null, 2),
  act: JSON.stringify(
    { steps: [{ ref: "Volume", action: "setValue", args: [80] }] },
    null,
    2
  ),
}

const pause = (ms: number) => new Promise((resolve) => setTimeout(resolve, ms))
const show = (value: unknown) =>
  typeof value === "string" ? `"${value}"` : JSON.stringify(value)

/** Puts the tile that holds a component in view and marks it while a step runs. */
function spotlight(ref: string | undefined) {
  for (const tile of document.querySelectorAll("[data-agent-target]")) {
    tile.removeAttribute("data-agent-target")
  }
  const tile = ref ? elementOf(ref)?.closest<HTMLElement>(".tile") : null
  if (tile) {
    tile.setAttribute("data-agent-target", "")
    tile.scrollIntoView({ block: "center", behavior: "smooth" })
  }
}

/**
 * Drives the sink through the page's agent bridge: canned requests an agent
 * answers with `act`, a console for the three tools, and every change as
 * `agent.subscribe` reports it, from a person or an agent. The same three
 * tools go to the browser's own agent through WebMCP.
 */
export class AgentPanel extends Component {
  agent = pageAgent()
  webMcp = hasWebMcp()
  tasks = tasks
  run = 0

  @tracked open = false
  @tracked running: Task | null = null
  @tracked log: Line[] = []
  @tracked pending: Pending | null = null
  @tracked changes: Change[] = []
  @tracked tool: Tool = "snapshot"
  @tracked input = ""
  @tracked output = ""

  constructor(owner: ConstructorParameters<typeof Component>[0], args: {}) {
    super(owner, args)
    const stopSharing = shareWithBrowser()
    const stopPending = onPending((pending) => {
      this.pending = pending
      if (pending) {
        this.open = true
      }
    })
    // A change can arrive while the page renders, like a part that commits
    // as it binds, so the list takes it after the render.
    const stopListening = this.agent.subscribe((change) => {
      const entry = { ...change, at: Date.now() }
      queueMicrotask(() => {
        if (!isDestroying(this)) {
          this.changes = [entry, ...this.changes].slice(0, 40)
        }
      })
    })
    registerDestructor(this, () => {
      this.run++
      spotlight(undefined)
      stopSharing()
      stopPending()
      stopListening()
    })
  }

  get hasLog() {
    return this.log.length > 0
  }

  toggle = () => {
    this.open = !this.open
  }

  close = () => {
    this.open = false
  }

  say = (line: Line) => {
    this.log = [...this.log, line]
  }

  isRunning = (task: Task) => this.running === task

  start = async (task: Task) => {
    const id = ++this.run
    const stale = () => this.run !== id
    this.running = task
    this.log = [{ kind: "task", text: task.prompt }]
    let ok = true
    for (const step of task.steps) {
      await pause(600)
      if (stale()) {
        return
      }
      const found = await this.agent.query({ text: step.ref })
      spotlight(Array.isArray(found) ? found[0]?.ref : undefined)
      await pause(400)
      const args = (step.args ?? []).map(show).join(", ")
      this.say({
        kind: "call",
        text: `act ${step.ref}.${step.action}(${args})`,
      })
      const result = await this.agent.act({ steps: [step] })
      if (stale()) {
        return
      }
      if (!result.ok) {
        this.say({ kind: "error", text: result.error?.message ?? "Failed" })
        ok = false
        break
      }
      const changes = result.steps[0]?.changes ?? []
      this.say({
        kind: "seen",
        text: changes.length
          ? changes.map((c) => `${c.key} → ${show(c.value)}`).join(", ")
          : step.action === "press"
            ? "pressed"
            : "no change",
      })
    }
    await pause(400)
    if (stale()) {
      return
    }
    if (ok) {
      this.say({ kind: "done", text: task.done })
    }
    spotlight(undefined)
    this.running = null
  }

  get asking() {
    return Boolean(this.pending)
  }

  allowStep = () => this.answer(true)

  // Closing it any other way, like Escape or Refuse, refuses the step.
  onAskOpenChange = (open: boolean) => {
    if (!open) {
      this.answer(false)
    }
  }

  answer = (allowed: boolean) => {
    const { pending } = this
    if (!pending) {
      return
    }
    this.say({
      kind: "ask",
      text: `${allowed ? "You allowed" : "You refused"}: ${pending.step.confirm}`,
    })
    pending.answer(allowed)
  }

  setTool = (value: string | null) => {
    if (value) {
      this.tool = value as Tool
      this.input = examples[this.tool]
      this.output = ""
    }
  }

  setInput = (event: Event) => {
    this.input = (event.target as HTMLTextAreaElement).value
  }

  get takesInput() {
    return this.tool !== "snapshot"
  }

  call = async () => {
    try {
      const input = this.input.trim() ? JSON.parse(this.input) : {}
      const result =
        this.tool === "snapshot"
          ? this.agent.snapshot()
          : this.tool === "query"
            ? await this.agent.query(input)
            : await this.agent.act(input)
      this.output = JSON.stringify(result, null, 2)
    } catch (error) {
      this.output = String(error)
    }
  }

  <template>
    <button
      type="button"
      class="agent-launch"
      aria-expanded={{if this.open "true" "false"}}
      aria-controls="agent-panel"
      {{on "click" this.toggle}}
    >{{icon Bot 16}} Agent</button>
    <aside
      id="agent-panel"
      class="agent-panel"
      aria-label="Agent"
      hidden={{unless this.open true}}
      data-agent-hidden
    >
      <header class="agent-head">
        <p class="agent-title">Agent</p>
        <p class="agent-webmcp" data-on={{if this.webMcp ""}}>
          {{#if this.webMcp}}
            Shared with this browser's agent through WebMCP.
          {{else}}
            This browser has no WebMCP, so the tools stay on
            <code>window.agent</code>.
          {{/if}}
        </p>
        <button
          type="button"
          class="agent-close"
          aria-label="Close agent"
          {{on "click" this.close}}
        >{{icon X 14}}</button>
      </header>

      {{! A modal of its own, so it can answer over a dialog the agent opened. }}
      <AlertDialog
        @open={{this.asking}}
        @onOpenChange={{this.onAskOpenChange}}
        as |d|
      >
        <d.Backdrop class="ov-backdrop" />
        <d.Content class="ov-dialog ov-alert agent-ask" data-agent-hidden>
          <d.Title class="ov-dialog-title">Let the agent do this?</d.Title>
          <d.Description class="ov-dialog-desc">
            {{this.pending.step.confirm}}
          </d.Description>
          <div class="ov-actions">
            <d.Close class="b-btn">Refuse</d.Close>
            <d.Close
              class="b-btn"
              data-variant="primary"
              @value="confirm"
              @action={{this.allowStep}}
            >{{icon Check 14}} Allow</d.Close>
          </div>
        </d.Content>
      </AlertDialog>

      <Tabs @defaultValue="tasks" class="agent-tabs" as |t|>
        <t.List class="agent-tab-list" aria-label="Agent">
          <t.Tab @value="tasks" class="agent-tab">Ask</t.Tab>
          <t.Tab @value="console" class="agent-tab">Console</t.Tab>
          <t.Tab @value="activity" class="agent-tab">Activity</t.Tab>
        </t.List>

        <t.Panel @value="tasks" class="agent-tab-panel">
          <p class="agent-note">Each request runs as an agent would answer it:
            it finds the components by label and calls their actions with
            <code>act</code>.</p>
          <ul class="agent-tasks">
            {{#each this.tasks as |task|}}
              <li>
                <button
                  type="button"
                  class="agent-task"
                  disabled={{if this.running true}}
                  data-running={{if (this.isRunning task) ""}}
                  {{on "click" (fn this.start task)}}
                >{{icon Play 12}}{{task.prompt}}</button>
              </li>
            {{/each}}
          </ul>
          {{#if this.hasLog}}
            <ol class="agent-log" aria-live="polite">
              {{#each this.log as |line|}}
                <li data-kind={{line.kind}}>{{line.text}}</li>
              {{/each}}
            </ol>
          {{/if}}
        </t.Panel>

        <t.Panel @value="console" class="agent-tab-panel">
          <SegmentedControl
            class="agent-tools"
            aria-label="Tool"
            @value={{this.tool}}
            @onValueChange={{this.setTool}}
            as |s|
          >
            <s.Indicator class="agent-tools-indicator" />
            <s.Item @value="snapshot">snapshot</s.Item>
            <s.Item @value="query">query</s.Item>
            <s.Item @value="act">act</s.Item>
          </SegmentedControl>
          {{#if this.takesInput}}
            <label class="agent-input-label">
              Input
              <textarea
                class="agent-input"
                rows="6"
                spellcheck="false"
                value={{this.input}}
                {{on "input" this.setInput}}
              ></textarea>
            </label>
          {{/if}}
          <button
            type="button"
            class="b-btn agent-call"
            data-variant="primary"
            {{on "click" this.call}}
          >Call {{this.tool}}</button>
          {{#if this.output}}
            <pre class="agent-output" aria-label="Result">{{this.output}}</pre>
          {{/if}}
        </t.Panel>

        <t.Panel @value="activity" class="agent-tab-panel">
          <p class="agent-note">Every change on the page, from you or the agent,
            as
            <code>agent.subscribe</code>
            reports it.</p>
          <ol class="agent-changes">
            {{#each this.changes as |change|}}
              <li>
                <span
                  class="agent-source"
                  data-source={{change.source}}
                >{{change.source}}</span>
                <span class="agent-change">{{change.label}}
                  <code>{{change.key}}</code>
                  {{show change.previous}}
                  →
                  {{show change.value}}</span>
              </li>
            {{else}}
              <li class="agent-empty">Nothing yet. Change something on the page.</li>
            {{/each}}
          </ol>
        </t.Panel>
      </Tabs>
    </aside>
  </template>
}
