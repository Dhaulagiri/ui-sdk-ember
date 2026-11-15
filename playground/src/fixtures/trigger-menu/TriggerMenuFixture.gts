import { on } from "@ember/modifier"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import {
  triggerMenuFixture as f,
  triggerMenuOptions,
} from "tests/fixtures/trigger-menu.ts"
import Composer from "./Composer.gts"

export default class TriggerMenuFixture extends Component {
  f = f
  options = triggerMenuOptions()
  @tracked action = ""
  @tracked open = ""
  @tracked submitted = ""

  setAction = (value: string) => (this.action = value)
  setOpen = (value: string) => (this.open = value)

  onSubmit = (event: SubmitEvent) => {
    event.preventDefault()
    this.submitted = String(
      new FormData(event.currentTarget as HTMLFormElement).get("message")
    )
  }

  <template>
    <div class="fixture">
      <button>Before</button>
      <form
        class="composer"
        aria-label={{f.formLabel}}
        {{on "submit" this.onSubmit}}
      >
        <Composer
          @name={{f.label}}
          @onAction={{this.setAction}}
          @onOpen={{this.setOpen}}
        />
        {{#if this.options.twice}}
          <Composer
            @name="Second"
            @onAction={{this.setAction}}
            @onOpen={{this.setOpen}}
          />
        {{/if}}
        <button type="submit">{{f.submit}}</button>
      </form>
      <button>After</button>
      <output role="status" aria-label="Last action">{{this.action}}</output>
      <output role="status" aria-label="Open">{{this.open}}</output>
      <output role="status" aria-label="Submitted">{{this.submitted}}</output>
    </div>
  </template>
}
