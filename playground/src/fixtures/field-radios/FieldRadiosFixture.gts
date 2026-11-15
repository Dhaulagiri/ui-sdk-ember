import { on } from "@ember/modifier"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Field } from "ember-ui-sdk/field"
import { RadioGroup } from "ember-ui-sdk/radio"
import {
  fieldRadiosFixture as f,
  fieldRadiosOptions,
} from "tests/fixtures/field.ts"

const isDisabled = (index: number, disabled: boolean) => index === 0 && disabled

export default class FieldRadiosFixture extends Component {
  f = f
  options = fieldRadiosOptions()
  @tracked firstDisabled = false

  toggleFirst = () => (this.firstDisabled = !this.firstDisabled)

  <template>
    <div class="fixture">
      <button>Before</button>
      <Field as |field|>
        <field.Label>{{this.f.label}}</field.Label>
        <RadioGroup
          class="form"
          @field={{field.field}}
          @name={{this.f.name}}
          as |g|
        >
          {{#each this.f.sizes key="value" as |size index|}}
            <Field
              class="row"
              @disabled={{isDisabled index this.options.disabledField}}
              as |row|
            >
              <g.Radio
                class="radio"
                @field={{row.field}}
                @value={{size.value}}
                @disabled={{isDisabled index this.firstDisabled}}
                as |r|
              >
                <r.Indicator class="radio-indicator" />
              </g.Radio>
              <row.Label>{{size.label}}</row.Label>
            </Field>
          {{/each}}
        </RadioGroup>
      </Field>
      <button>After</button>
      <button {{on "click" this.toggleFirst}}>{{this.f.disableFirst}}</button>
    </div>
  </template>
}
