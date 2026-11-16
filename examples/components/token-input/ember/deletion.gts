import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Check, ChevronDown, File } from "lucide"
import { Field } from "ember-ui-sdk/field"
import { Select } from "ember-ui-sdk/select"
import { TokenInput } from "ember-ui-sdk/token-input"
import { TriggerMenu } from "ember-ui-sdk/trigger-menu"
import { icon } from "../../../shared/ember/icon"
import { useLog } from "../../../shared/ember/log"

const modes = [
  { value: "whole", label: "Whole" },
  { value: "select", label: "Select" },
  { value: "revert", label: "Revert" },
]

const files = [
  { value: "src/app.tsx", label: "app.tsx", keywords: ["src"] },
  { value: "src/routes.ts", label: "routes.ts", keywords: ["src"] },
  { value: "src/styles.css", label: "styles.css", keywords: ["src"] },
  { value: "README.md", label: "README.md" },
  { value: "package.json", label: "package.json" },
]

const draft = [
  "Explain ",
  {
    type: "file",
    value: "src/routes.ts",
    label: "routes.ts",
    data: { trigger: "@" },
  },
  " in two sentences.",
]

export default class Deletion extends Component {
  log = useLog(this)
  modes = modes
  files = files
  draft = draft
  triggers = [{ char: "@", type: "file", items: files }]
  @tracked deletion = "whole"

  onDeletionChange = (next: string | null) => {
    if (next) this.deletion = next
  }

  onValueChange = (
    _value: unknown,
    details: { removed: { label: string }[] }
  ) => {
    for (const token of details.removed) {
      this.log(`Removed ${token.label} (${this.deletion})`)
    }
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <Select
          @items={{this.modes}}
          @value={{this.deletion}}
          @onValueChange={{this.onDeletionChange}}
          as |s|
        >
          <s.Label>Backspace</s.Label>
          <s.Trigger>
            <s.Value />
            {{icon ChevronDown}}
          </s.Trigger>
          <s.Content>
            {{#each this.modes key="value" as |mode|}}
              <s.Item @value={{mode.value}} as |item|>
                {{mode.label}}
                <item.Indicator>{{icon Check}}</item.Indicator>
              </s.Item>
            {{/each}}
          </s.Content>
        </Select>
      </div>
      <Field as |f|>
        <f.Label>Prompt</f.Label>
        <TokenInput
          @tokenDeletion={{this.deletion}}
          @defaultValue={{this.draft}}
          @onValueChange={{this.onValueChange}}
          @field={{f.field}}
          as |t|
        >
          <t.Tokens as |token parts|>
            <parts.Token>
              {{icon File}}
              {{token.label}}
            </parts.Token>
          </t.Tokens>
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
    </div>
  </template>
}
