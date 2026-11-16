import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { on } from "@ember/modifier"
import { Check } from "lucide"
import { Checkbox } from "ember-ui-sdk/checkbox"
import { Field } from "ember-ui-sdk/field"
import { TokenInput } from "ember-ui-sdk/token-input"
import { icon } from "../../../shared/ember/icon"
import { useLog } from "../../../shared/ember/log"

const draft = [
  "Explain ",
  { type: "file", value: "src/routes.ts", label: "routes.ts" },
  " in two sentences.",
]

let count = 0

export default class Form extends Component {
  log = useLog(this)
  draft = draft
  formId = `token-input-form-${++count}`
  @tracked disabled = false
  @tracked readOnly = false

  onDisabledChange = (next: boolean | "indeterminate") => {
    this.disabled = next === true
  }

  onReadOnlyChange = (next: boolean | "indeterminate") => {
    this.readOnly = next === true
  }

  onSubmit = (event: SubmitEvent) => {
    event.preventDefault()
    this.log(
      `Submitted ${new FormData(event.currentTarget as HTMLFormElement).get("prompt") ?? ""}`
    )
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <label data-slot="label">
          <Checkbox
            @checked={{this.disabled}}
            @onCheckedChange={{this.onDisabledChange}}
            as |c|
          >
            <c.Indicator>{{icon Check}}</c.Indicator>
          </Checkbox>
          Disabled
        </label>
        <label data-slot="label">
          <Checkbox
            @checked={{this.readOnly}}
            @onCheckedChange={{this.onReadOnlyChange}}
            as |c|
          >
            <c.Indicator>{{icon Check}}</c.Indicator>
          </Checkbox>
          Read-only
        </label>
      </div>
      <div data-slot="stack">
        <Field @disabled={{this.disabled}} as |f|>
          <f.Label>Prompt</f.Label>
          <TokenInput
            @form={{this.formId}}
            @name="prompt"
            @required={{true}}
            @defaultValue={{this.draft}}
            @readOnly={{this.readOnly}}
            @field={{f.field}}
            as |t|
          >
            <t.Editor />
          </TokenInput>
        </Field>
        <form id={{this.formId}} data-slot="row" {{on "submit" this.onSubmit}}>
          <button type="submit" data-variant="solid">Submit</button>
          <button type="reset">Reset</button>
        </form>
      </div>
    </div>
  </template>
}
