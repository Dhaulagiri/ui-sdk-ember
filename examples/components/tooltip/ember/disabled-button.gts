import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { on } from "@ember/modifier"
import { Field } from "ember-ui-sdk/field"
import { Input } from "ember-ui-sdk/input"
import { Tooltip } from "ember-ui-sdk/tooltip"
import { useLog } from "../../../shared/ember/log"

export default class DisabledButton extends Component {
  log = useLog(this)
  @tracked title = ""

  get blocked() {
    return !this.title.trim()
  }

  get notBlocked() {
    return !this.blocked
  }

  onTitleChange = (next: string) => {
    this.title = next
  }

  publish = () => {
    if (!this.blocked) {
      this.log(`Published “${this.title.trim()}”`)
    }
  }

  <template>
    <div data-slot="stack">
      <Field as |f|>
        <f.Label>Post title</f.Label>
        <Input
          @value={{this.title}}
          @onValueChange={{this.onTitleChange}}
          @field={{f.field}}
        />
      </Field>
      <Tooltip @disabled={{this.notBlocked}} as |t|>
        <t.Trigger
          data-variant="solid"
          aria-disabled={{if this.blocked "true"}}
          {{on "click" this.publish}}
        >
          Publish
        </t.Trigger>
        <t.Content @side="right">Add a title to publish</t.Content>
      </Tooltip>
    </div>
  </template>
}
