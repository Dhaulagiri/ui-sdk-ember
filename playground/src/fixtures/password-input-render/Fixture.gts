import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { PasswordInput } from "ember-ui-sdk/password-input"

const toggleClass = (visible: boolean) =>
  `password-toggle ${visible ? "is-visible" : "is-hidden"}`
const label = (visible: boolean) => (visible ? "Hide" : "Show")

export default class PasswordInputRenderFixture extends Component {
  @tracked action = ""

  onVisibleChange = (visible: boolean) => (this.action = `visible: ${visible}`)

  <template>
    <div class="fixture">
      <button>Before</button>
      <PasswordInput
        class="password-input"
        @onVisibleChange={{this.onVisibleChange}}
        as |p|
      >
        <p.Control class="input" aria-label="Password" />
        <p.Toggle @render={{true}} as |t|>
          <span
            {{t.part}}
            aria-label="Show password"
            class={{toggleClass t.state.visible}}
          >
            <span aria-hidden="true">{{label t.state.visible}}</span>
          </span>
        </p.Toggle>
      </PasswordInput>
      <button>After</button>
      <output role="status" aria-label="Last action">{{this.action}}</output>
    </div>
  </template>
}
