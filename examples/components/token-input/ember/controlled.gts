import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Field } from "ember-ui-sdk/field"
import { toText, TokenInput } from "ember-ui-sdk/token-input"
import { TriggerMenu } from "ember-ui-sdk/trigger-menu"
import { useLog } from "../../../shared/ember/log"

const files = [
  { value: "src/app.tsx", label: "app.tsx", keywords: ["src"] },
  { value: "src/routes.ts", label: "routes.ts", keywords: ["src"] },
  { value: "src/styles.css", label: "styles.css", keywords: ["src"] },
  { value: "README.md", label: "README.md" },
  { value: "package.json", label: "package.json" },
]

const draft = [
  "Explain ",
  { type: "file", value: "src/routes.ts", label: "routes.ts" },
  " in two sentences.",
]

const history = { limit: 50, groupDelay: 1000 }

const describe = (token: { type: string }) =>
  token.type === "file" ? "attached file" : token.type

export default class Controlled extends Component {
  log = useLog(this)
  files = files
  history = history
  describe = describe
  triggers = [{ char: "@", type: "file", items: files }]
  @tracked value = draft

  onValueChange = (
    next: typeof draft,
    details: { reason: string; removed: { label: string }[] }
  ) => {
    this.value = next
    const removed = details.removed.map((token) => token.label).join(", ")
    this.log(
      `${toText(next)} (${details.reason}${removed ? `, removed ${removed}` : ""})`
    )
  }

  <template>
    <Field as |f|>
      <f.Label>Prompt</f.Label>
      <TokenInput
        @value={{this.value}}
        @onValueChange={{this.onValueChange}}
        @history={{this.history}}
        @getTokenDescription={{this.describe}}
        @field={{f.field}}
        as |t|
      >
        <t.Editor />
        <TriggerMenu @editor={{t.editor}} @triggers={{this.triggers}} as |m|>
          <m.Content>
            <m.List as |list|>
              {{#each list.state.items key="value" as |item|}}
                <m.Item @value={{item.value}} @label={{item.label}}>
                  {{item.label}}
                </m.Item>
              {{/each}}
            </m.List>
          </m.Content>
        </TriggerMenu>
      </TokenInput>
    </Field>
  </template>
}
