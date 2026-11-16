import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Button } from "ember-ui-sdk/button"
import { Field } from "ember-ui-sdk/field"
import { Input } from "ember-ui-sdk/input"
import { useLog } from "../../../shared/ember/log"

export default class FocusableWhenDisabled extends Component {
  log = useLog(this)
  @tracked title = ""

  get ready() {
    return this.title.trim() !== ""
  }

  get notReady() {
    return !this.ready
  }

  get readyText() {
    return this.ready ? "Ready to publish." : "Add a title to publish."
  }

  onTitle = (value: string) => {
    this.title = value
  }

  publish = () => this.log(`Published “${this.title}”`)

  <template>
    <div data-slot="stack">
      <Field as |f|>
        <f.Label>Title</f.Label>
        <Input
          @value={{this.title}}
          @onValueChange={{this.onTitle}}
          @field={{f.field}}
        />
      </Field>
      <div data-slot="row">
        <Button
          @disabled={{this.notReady}}
          @focusableWhenDisabled={{true}}
          aria-describedby="publish-hint"
          @onClick={{this.publish}}
        >
          Publish
        </Button>
        <p id="publish-hint" data-slot="hint">{{this.readyText}}</p>
      </div>
    </div>
  </template>
}
