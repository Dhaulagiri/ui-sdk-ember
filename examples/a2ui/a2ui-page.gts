import { registerDestructor } from "@ember/destroyable"
import { on } from "@ember/modifier"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { A2uiSession, A2uiSurfaces } from "ember-a2ui"
import { createAgent, type AgentComponent } from "ember-ui-sdk/agent"
import { elementOf } from "ember-ui-sdk/observe"
import { onInsert } from "../sink/on-insert.ts"
import { BASIC_CATALOG_ID, replaced, uiSdkCatalog } from "./catalog.ts"
import { messages, respond } from "./stream.ts"
import "./a2ui.css"

type Line = { kind: "call" | "seen" | "skip" | "done" | "error"; text: string }

/** What the agent fills when a field is still empty, by the label the surface gives it. */
const plan: { label: string; action: string; args: unknown[] }[] = [
  { label: "Traveler", action: "setValue", args: ["Ada Lovelace"] },
  { label: "Destination", action: "setValue", args: ["Lisbon"] },
  { label: "Extras", action: "setValue", args: [["bag", "seat"]] },
  { label: "Departure", action: "setValue", args: ["2026-12-18"] },
  { label: "Nights", action: "setValue", args: [5] },
]

const isEmpty = (value: unknown) =>
  value === null ||
  value === undefined ||
  value === "" ||
  (Array.isArray(value) && value.length === 0)

const show = (value: unknown) => JSON.stringify(value)
const pretty = (value: unknown) => JSON.stringify(value, null, 2)

function makeSession(catalog: ReturnType<typeof uiSdkCatalog> | null) {
  const session: A2uiSession = new A2uiSession({
    ...(catalog ? { catalogs: [catalog] } : {}),
    onAction: (action) => {
      // The mock agent answers on the next tick, as a network reply would.
      setTimeout(() => session.processMessages(respond(action as never)), 300)
    },
  })
  session.processMessages(structuredClone(messages))
  return session
}

/**
 * One agent message stream, drawn twice: by the basic catalog's own elements,
 * and by the same catalog with its inputs drawn by ember-ui-sdk. The agent's
 * JSON is the same; only the second is something an agent can also read and
 * fill, through ui-sdk's agent bridge.
 */
export class A2uiPage extends Component {
  // Created before the surfaces render, so it hears their components.
  agent = createAgent()
  basic = makeSession(null)
  // Registered under the basic catalog's id, so the agent's surface gets it.
  uiSdk = makeSession(uiSdkCatalog(BASIC_CATALOG_ID))
  replaced = replaced.join(", ")
  uiSdkHost: HTMLElement | null = null
  basicHost: HTMLElement | null = null

  @tracked revision = 0
  @tracked log: Line[] = []
  @tracked running = false
  @tracked seen: { basic: number; uiSdk: number } | null = null

  constructor(owner: ConstructorParameters<typeof Component>[0], args: {}) {
    super(owner, args)
    // Inputs write the data model; the JSON beside each surface follows.
    const timer = setInterval(() => this.revision++, 400)
    registerDestructor(this, () => {
      clearInterval(timer)
      this.basic.dispose()
      this.uiSdk.dispose()
    })
  }

  dataModel = (session: A2uiSession) => {
    void this.revision
    const surface = session.surfaces[0]
    return pretty(surface?.dataModel.get("/") ?? {})
  }

  setUiSdkHost = (el: HTMLElement) => {
    this.uiSdkHost = el
  }

  setBasicHost = (el: HTMLElement) => {
    this.basicHost = el
  }

  within(host: HTMLElement | null) {
    return (component: AgentComponent) => {
      const el = elementOf(component.ref)
      return Boolean(el && host?.contains(el))
    }
  }

  say = (line: Line) => {
    this.log = [...this.log, line]
  }

  look = () => {
    const page = this.agent.snapshot()
    this.seen = {
      basic: page.filter(this.within(this.basicHost)).length,
      uiSdk: page.filter(this.within(this.uiSdkHost)).length,
    }
  }

  fill = async () => {
    this.running = true
    this.log = []
    this.say({ kind: "call", text: "snapshot()" })
    const mine = this.agent.snapshot().filter(this.within(this.uiSdkHost))
    this.seen = {
      basic: this.agent.snapshot().filter(this.within(this.basicHost)).length,
      uiSdk: mine.length,
    }
    for (const step of plan) {
      const component = mine.find((c) => c.label?.startsWith(step.label))
      if (!component) {
        this.say({ kind: "error", text: `No ${step.label} on the surface` })
        continue
      }
      const current =
        "checked" in component ? component.checked : component.value
      if (!isEmpty(current) && step.label !== "Nights") {
        this.say({
          kind: "skip",
          text: `${step.label} is ${show(current)}, kept`,
        })
        continue
      }
      this.say({
        kind: "call",
        text: `act ${component.ref}.${step.action}(${step.args.map(show).join(", ")})`,
      })
      const result = await this.agent.act({
        steps: [{ ref: component.ref, action: step.action, args: step.args }],
      })
      if (!result.ok) {
        this.say({ kind: "error", text: result.error?.message ?? "Failed" })
        continue
      }
      const changes = result.steps[0]?.changes ?? []
      this.say({
        kind: "seen",
        text:
          changes.map((c) => `${c.key} → ${show(c.value)}`).join(", ") ||
          "no change",
      })
      await new Promise((resolve) => setTimeout(resolve, 250))
    }
    this.say({ kind: "call", text: 'act press "Find trips"' })
    const pressed = await this.agent.act({
      steps: [{ ref: "Find trips", action: "press" }],
    })
    this.say(
      pressed.ok
        ? {
            kind: "done",
            text: "Pressed Find trips: the action went back to the agent.",
          }
        : { kind: "error", text: pressed.error?.message ?? "Failed" }
    )
    this.running = false
  }

  <template>
    <div class="a2-page">
      <header class="a2-intro">
        <h1>A2UI with ember-ui-sdk</h1>
        <p>An agent sends this form as
          <a href="https://a2ui.org">A2UI</a>
          messages for the basic catalog. On the left,
          <a href="https://github.com/Dhaulagiri/ember-a2ui">ember-a2ui</a>
          draws it with the catalog's own elements. On the right, the same
          messages draw with a catalog whose inputs are ember-ui-sdk parts:
          {{this.replaced}}. Fill either one in, and the data model below it
          changes the same way.</p>
      </header>

      <section class="a2-agent" aria-label="Agent" data-example>
        <div class="a2-agent-actions">
          <button type="button" class="a2-btn" {{on "click" this.look}}>What can
            an agent see?</button>
          <button
            type="button"
            class="a2-btn"
            data-variant="primary"
            disabled={{this.running}}
            {{on "click" this.fill}}
          >Let the agent fill the rest</button>
        </div>
        {{#if this.seen}}
          <p class="a2-seen" aria-live="polite">
            <code>agent.snapshot()</code>
            finds
            <strong>{{this.seen.basic}}</strong>
            components in the basic catalog's surface and
            <strong>{{this.seen.uiSdk}}</strong>
            in the ui-sdk one.
          </p>
        {{/if}}
        {{#if this.log.length}}
          <ol class="a2-log" aria-label="Agent log">
            {{#each this.log as |line|}}
              <li data-kind={{line.kind}}>{{line.text}}</li>
            {{/each}}
          </ol>
        {{/if}}
      </section>

      <div class="a2-columns">
        <section class="a2-column" aria-labelledby="a2-basic-title">
          <h2 id="a2-basic-title">Basic catalog</h2>
          <div class="a2-surface" data-example {{onInsert this.setBasicHost}}>
            <A2uiSurfaces @session={{this.basic}} />
          </div>
          <details class="a2-model">
            <summary>Data model</summary>
            <pre>{{this.dataModel this.basic}}</pre>
          </details>
        </section>
        <section class="a2-column" aria-labelledby="a2-uisdk-title">
          <h2 id="a2-uisdk-title">ui-sdk catalog</h2>
          <div
            class="a2-surface a2-uisdk"
            data-example
            {{onInsert this.setUiSdkHost}}
          >
            <A2uiSurfaces @session={{this.uiSdk}} />
          </div>
          <details class="a2-model" open>
            <summary>Data model</summary>
            <pre>{{this.dataModel this.uiSdk}}</pre>
          </details>
        </section>
      </div>
    </div>
  </template>
}
