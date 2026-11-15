import { on } from "@ember/modifier"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Field, FieldSet } from "ember-ui-sdk/field"
import { Input, InputGroup } from "ember-ui-sdk/input"
import { Textarea } from "ember-ui-sdk/textarea"

const filled = (isFilled: unknown) => (isFilled ? "filled" : "empty")

export default class FormRenderFixture extends Component {
  @tracked renders = 0

  rerender = () => this.renders++

  <template>
    <div class="fixture">
      <button>Before</button>
      <FieldSet class="form" as |s|>
        <s.Legend @render={{true}} as |l|>
          <div {{l.part}}>Legend as a div</div>
        </s.Legend>
        <Field as |field|>
          <field.Label>Render function</field.Label>
          <Input @field={{field.field}} @render={{true}} as |i|>
            <input
              {{i.part}}
              class="input"
              data-state={{filled i.state.filled}}
            />
          </Input>
        </Field>
        <Field as |field|>
          <field.Label>Class from state</field.Label>
          <Textarea
            @field={{field.field}}
            @autoResize={{true}}
            class="textarea"
          />
        </Field>
        <InputGroup class="input-group" as |g|>
          <Input class="input" aria-label="Search" />
          <g.Clear @render={{true}} as |c|>
            <span
              {{c.part}}
              role="button"
              tabindex="0"
              aria-label="Clear search"
            >×</span>
          </g.Clear>
        </InputGroup>
      </FieldSet>
      <button type="button" {{on "click" this.rerender}}>Render again ({{this.renders}})</button>
      <button>After</button>
    </div>
  </template>
}
