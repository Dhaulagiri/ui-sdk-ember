import { on } from "@ember/modifier"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Checkbox } from "ember-ui-sdk/checkbox"
import { Field } from "ember-ui-sdk/field"
import { RadioGroup } from "ember-ui-sdk/radio"
import { Switch } from "ember-ui-sdk/switch"

const checkedLabel = (checked: unknown) => (checked ? "On" : "Off")
const thumb = (checked: boolean) => (checked ? "I" : "O")
const sizeLabel = (value: string) => (value === "small" ? "Small" : "Large")

export default class FormsRenderFixture extends Component {
  sizes = ["small", "large"]
  @tracked action = ""
  @tracked nickname = ""

  onNickname = (event: Event) => {
    this.nickname = (event.target as HTMLInputElement).value
  }
  onSpan = (checked: unknown) => (this.action = `span:${String(checked)}`)
  onSize = (value: string | null) => (this.action = `size:${value}`)
  prevent = (event: Event) => event.preventDefault()

  <template>
    <div class="fixture">
      <button>Before</button>
      <form class="form" aria-label="Rendering" {{on "submit" this.prevent}}>
        <label>
          <Checkbox @onCheckedChange={{this.onSpan}} @render={{true}} as |c|>
            <span {{c.part}} class="checkbox">
              <c.Indicator class="checkbox-indicator" />
            </span>
          </Checkbox>
          Rendered as a span
        </label>
        <Checkbox @render={{true}} as |c|>
          <button {{c.part}} aria-label="Render function">{{checkedLabel
              c.state.checked
            }}</button>
        </Checkbox>
        <Checkbox aria-label="Class from state" as |c|>
          <span hidden data-class={{c.state.checked}}></span>
        </Checkbox>
        <label>
          <Switch class="switch" @defaultChecked={{true}} as |s|>
            <s.Thumb as |t|>{{thumb t.state.checked}}</s.Thumb>
          </Switch>
          Labelled thumb
        </label>
        <RadioGroup
          aria-label="Size"
          @defaultValue="small"
          @onValueChange={{this.onSize}}
          as |g|
        >
          {{#each this.sizes key="@identity" as |value|}}
            <label>
              <g.Radio @value={{value}} @render={{true}} as |r|>
                <span {{r.part}} class="radio"></span>
              </g.Radio>
              {{sizeLabel value}}
            </label>
          {{/each}}
        </RadioGroup>
        <Field as |field|>
          <field.Label>Nickname</field.Label>
          <field.Control
            value={{this.nickname}}
            {{on "input" this.onNickname}}
          />
        </Field>
      </form>
      <button>After</button>
      <output role="status" aria-label="Last action">{{this.action}}</output>
    </div>
  </template>
}
