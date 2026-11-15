import { registerDestructor } from "@ember/destroyable"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Checkbox } from "ember-ui-sdk/checkbox"
import { Field, FieldLabel } from "ember-ui-sdk/field"
import {
  fieldChoiceCardFixture as f,
  fieldChoiceCardOptions,
} from "tests/fixtures/field.ts"

export default class FieldChoiceCardFixture extends Component {
  f = f
  options = fieldChoiceCardOptions()
  @tracked ready = false

  constructor(owner: unknown, args: object) {
    super(owner as never, args)
    const timer = setTimeout(() => (this.ready = true), f.later.delay)
    registerDestructor(this, () => clearTimeout(timer))
  }

  <template>
    <div class="fixture">
      <button>Before</button>
      {{#each this.f.cards key="name" as |card|}}
        <FieldLabel class="choice-card">
          <Field as |field|>
            <Checkbox
              class="checkbox"
              @field={{field.field}}
              @name={{card.name}}
              as |c|
            >
              <c.Indicator class="checkbox-indicator" />
            </Checkbox>
            <span>{{card.title}}</span>
            <field.Description>{{card.description}}</field.Description>
          </Field>
        </FieldLabel>
      {{/each}}
      {{#if this.options.later}}
        <FieldLabel class="choice-card">
          <Field as |field|>
            {{#if this.ready}}
              <Checkbox
                class="checkbox"
                @field={{field.field}}
                @name={{this.f.later.name}}
                as |c|
              >
                <c.Indicator class="checkbox-indicator" />
              </Checkbox>
            {{/if}}
            <span>{{this.f.later.title}}</span>
            <field.Description>{{this.f.later.description}}</field.Description>
          </Field>
        </FieldLabel>
      {{/if}}
      {{#if this.options.alone}}
        <FieldLabel>{{this.f.alone}}</FieldLabel>
      {{/if}}
      <button>After</button>
    </div>
  </template>
}
