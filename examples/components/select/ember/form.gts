import { on } from "@ember/modifier"
import Component from "@glimmer/component"
import { Check, ChevronDown } from "lucide"
import { Field } from "ember-ui-sdk/field"
import { Select } from "ember-ui-sdk/select"
import { icon } from "../../../shared/ember/icon"
import { useLog } from "../../../shared/ember/log"

const countries = [
  { value: "au", label: "Australia" },
  { value: "br", label: "Brazil" },
  { value: "ca", label: "Canada" },
  { value: "fr", label: "France" },
  { value: "de", label: "Germany" },
  { value: "jp", label: "Japan" },
  { value: "es", label: "Spain" },
  { value: "se", label: "Sweden" },
]

const topics = ["Design", "Engineering", "Marketing", "Research", "Sales"]

const frequencies = ["Daily", "Weekly", "Monthly"]

export default class Form extends Component {
  log = useLog(this)
  defaultTopics = ["Design"]

  submit = (event: SubmitEvent) => {
    event.preventDefault()
    const entries = [
      ...new FormData(event.currentTarget as HTMLFormElement),
    ].map(([name, value]) => `${name}=${value}`)
    this.log(`Submitted ${entries.join("&")}`)
  }

  <template>
    <div data-slot="stack">
      <form
        id="select-newsletter"
        data-slot="stack"
        {{on "submit" this.submit}}
      >
        <Field as |f|>
          <f.Label>Country</f.Label>
          <Select
            @name="country"
            @autoComplete="country"
            @required={{true}}
            @placeholder="Select a country"
            as |s|
          >
            <s.Trigger @field={{f.field}}>
              <s.Value />
              {{icon ChevronDown}}
            </s.Trigger>
            <s.Content>
              {{#each countries key="value" as |country|}}
                <s.Item @value={{country.value}} as |item|>
                  {{country.label}}
                  <item.Indicator>{{icon Check}}</item.Indicator>
                </s.Item>
              {{/each}}
            </s.Content>
          </Select>
        </Field>
        <Field as |f|>
          <f.Label>Topics</f.Label>
          <Select
            @name="topics"
            @multiple={{true}}
            @defaultValue={{this.defaultTopics}}
            as |s|
          >
            <s.Trigger @field={{f.field}}>
              <s.Value />
              {{icon ChevronDown}}
            </s.Trigger>
            <s.Content>
              {{#each topics key="@identity" as |topic|}}
                <s.Item @value={{topic}} as |item|>
                  {{topic}}
                  <item.Indicator>{{icon Check}}</item.Indicator>
                </s.Item>
              {{/each}}
            </s.Content>
          </Select>
        </Field>
      </form>
      <Field as |f|>
        <f.Label>Frequency</f.Label>
        <Select
          @name="frequency"
          @form="select-newsletter"
          @defaultValue="Weekly"
          as |s|
        >
          <s.Trigger @field={{f.field}}>
            <s.Value />
            {{icon ChevronDown}}
          </s.Trigger>
          <s.Content>
            {{#each frequencies key="@identity" as |frequency|}}
              <s.Item @value={{frequency}} as |item|>
                {{frequency}}
                <item.Indicator>{{icon Check}}</item.Indicator>
              </s.Item>
            {{/each}}
          </s.Content>
        </Select>
      </Field>
      <div data-slot="row">
        <button type="submit" form="select-newsletter" data-variant="solid">
          Save
        </button>
        <button type="reset" form="select-newsletter">Reset</button>
      </div>
    </div>
  </template>
}
