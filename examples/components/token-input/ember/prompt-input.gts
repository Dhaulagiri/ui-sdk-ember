import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { on } from "@ember/modifier"
import { ArrowUp, Check, Clock, Code, File, X } from "lucide"
import {
  createTokenInputController,
  toText,
  TokenInput,
  type TokenInputValue,
} from "ember-ui-sdk/token-input"
import { TriggerMenu } from "ember-ui-sdk/trigger-menu"
import { icon } from "../../../shared/ember/icon"
import { useLog } from "../../../shared/ember/log"

const files = [
  { value: "src/app.tsx", label: "app.tsx", keywords: ["src"] },
  { value: "src/routes.ts", label: "routes.ts", keywords: ["src"] },
  { value: "src/styles.css", label: "styles.css", keywords: ["src"] },
  { value: "README.md", label: "README.md" },
  { value: "package.json", label: "package.json" },
]

const skills = [
  {
    value: "search",
    label: "search",
    arguments: [{ name: "query", hint: "<query>", required: true }],
  },
  { value: "review", label: "review" },
  { value: "summarize", label: "summarize" },
]

const loadFile = () => new Promise<void>((resolve) => setTimeout(resolve, 800))

const isSkill = (token: { type: string }) => token.type === "skill"
const isRunning = (token: { data?: { run?: string } }) =>
  token.data?.run === "running"
const isDone = (token: { data?: { run?: string } }) =>
  token.data?.run === "done"
const labelOf = (token: { type: string; label: string }) =>
  token.type === "skill" ? `/${token.label}` : token.label

export default class PromptInput extends Component {
  log = useLog(this)
  prompt = createTokenInputController()
  triggers = [
    { char: "@", type: "file", items: files },
    { char: "/", boundary: "start", type: "skill", items: skills },
  ]
  isSkill = isSkill
  isRunning = isRunning
  isDone = isDone
  labelOf = labelOf
  @tracked running = false
  sendTimer?: ReturnType<typeof setTimeout>

  willDestroy() {
    super.willDestroy()
    clearTimeout(this.sendTimer)
  }

  keepFocus = (event: MouseEvent) => {
    event.preventDefault()
  }

  attachReadme = () => {
    this.prompt.insert(
      { type: "file", value: "README.md", label: "README.md" },
      { resolve: loadFile() }
    )
  }

  onSelect = (_value: unknown, details: { trigger: string }) =>
    details.trigger === "@" ? loadFile() : undefined

  send = (value: TokenInputValue) => {
    if (this.running || !this.prompt.getLabel().trim()) {
      return
    }
    this.running = true
    const skillTokens = value.filter(
      (segment) => typeof segment !== "string" && segment.type === "skill"
    )
    for (const skill of skillTokens) {
      if (typeof skill !== "string") {
        this.prompt.updateToken(skill.id!, {
          data: { ...skill.data, run: "running" },
        })
      }
    }
    this.sendTimer = setTimeout(() => {
      for (const skill of skillTokens) {
        if (typeof skill !== "string") {
          this.prompt.updateToken(skill.id!, {
            data: { ...skill.data, run: "done" },
          })
        }
      }
      this.log(`Sent ${toText(this.prompt.getValue())}`)
      this.prompt.clear()
      this.running = false
    }, 1500)
  }

  sendPrompt = () => {
    this.send(this.prompt.getValue())
  }

  <template>
    <TokenInput @controller={{this.prompt}} @onSubmit={{this.send}} as |t|>
      <t.Tokens as |token parts|>
        <parts.Token>
          {{#if (this.isSkill token)}}
            {{icon Code}}
          {{else}}
            {{icon File}}
          {{/if}}
          {{this.labelOf token}}
          {{#if (this.isRunning token)}}
            {{icon Clock}}
          {{/if}}
          {{#if (this.isDone token)}}
            {{icon Check}}
          {{/if}}
          <parts.Remove>{{icon X}}</parts.Remove>
        </parts.Token>
      </t.Tokens>
      <div data-slot="card">
        <t.Editor aria-label="Prompt" placeholder="Ask anything. Type @ or /" />
        <div data-slot="row">
          <button
            type="button"
            data-size="sm"
            {{on "mousedown" this.keepFocus}}
            {{on "click" this.attachReadme}}
          >
            Attach README
          </button>
          <button
            type="button"
            data-variant="solid"
            data-size="sm"
            data-shape="round"
            aria-label={{if this.running "Running" "Send"}}
            disabled={{this.running}}
            {{on "click" this.sendPrompt}}
          >
            {{#if this.running}}
              {{icon Clock}}
            {{else}}
              {{icon ArrowUp}}
            {{/if}}
          </button>
        </div>
      </div>
      <TriggerMenu
        @editor={{t.editor}}
        @triggers={{this.triggers}}
        @onSelect={{this.onSelect}}
        as |m|
      >
        <m.Hint />
        <m.Content>
          <m.Empty>No matches</m.Empty>
          <m.List as |list|>
            {{#each list.state.items key="value" as |item|}}
              <m.Item
                @value={{item.value}}
                @label={{item.label}}
                @disabled={{item.disabled}}
              >
                {{item.label}}
              </m.Item>
            {{/each}}
          </m.List>
        </m.Content>
      </TriggerMenu>
    </TokenInput>
  </template>
}
