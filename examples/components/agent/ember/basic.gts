import { registerDestructor } from "@ember/destroyable"
import { on } from "@ember/modifier"
import Component from "@glimmer/component"
import { createAgent } from "ember-ui-sdk/agent"
import { Field } from "ember-ui-sdk/field"
import { Select } from "ember-ui-sdk/select"
import { Switch } from "ember-ui-sdk/switch"
import { Check, ChevronDown } from "lucide"
import { icon } from "../../../shared/ember/icon"
import { useLog } from "../../../shared/ember/log"

const regions = [
  { value: "europe", label: "Europe" },
  { value: "north-america", label: "North America" },
  { value: "asia-pacific", label: "Asia Pacific" },
]

export default class Basic extends Component {
  log = useLog(this)
  // Created before the template renders, so it hears both components.
  agent = createAgent()

  constructor(owner: ConstructorParameters<typeof Component>[0], args: {}) {
    super(owner, args)
    const stop = this.agent.subscribe((change) =>
      this.log(
        `${change.label} ${change.key} → ${JSON.stringify(change.value)} (${change.source})`
      )
    )
    registerDestructor(this, stop)
  }

  snapshot = () => {
    for (const component of this.agent.snapshot()) {
      const state = "checked" in component ? component.checked : component.value
      this.log(
        `${component.ref} ${component.component} "${component.label}": ${JSON.stringify(state)}`
      )
    }
  }

  act = async () => {
    const result = await this.agent.act({
      steps: [
        { ref: "Region", action: "setValue", args: ["Asia Pacific"] },
        { ref: "Preview deployments", action: "setChecked", args: [true] },
      ],
    })
    this.log(result.ok ? "act: ok" : `act: ${result.error?.message}`)
  }

  <template>
    <div data-slot="stack">
      <Field as |f|>
        <f.Label>Region</f.Label>
        <Select @items={{regions}} @defaultValue="europe" as |s|>
          <s.Trigger @field={{f.field}}>
            <s.Value />
            {{icon ChevronDown}}
          </s.Trigger>
          <s.Content>
            {{#each regions key="value" as |region|}}
              <s.Item @value={{region.value}} as |item|>
                {{region.label}}
                <item.Indicator>{{icon Check}}</item.Indicator>
              </s.Item>
            {{/each}}
          </s.Content>
        </Select>
      </Field>
      <label data-slot="label">
        Preview deployments
        <Switch as |s|><s.Thumb /></Switch>
      </label>
      <div data-slot="row">
        <button type="button" {{on "click" this.snapshot}}>Snapshot</button>
        <button type="button" {{on "click" this.act}}>Let the agent do it</button>
      </div>
    </div>
  </template>
}
