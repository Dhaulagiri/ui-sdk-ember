import Component from "@glimmer/component"
import { fn } from "@ember/helper"
import { on } from "@ember/modifier"
import { Toolbar } from "ember-ui-sdk/toolbar"
import { Bold, Italic, Link, Underline } from "lucide"
import { icon } from "../../../shared/ember/icon"
import { useLog } from "../../../shared/ember/log"

const styles = [
  { label: "Bold", icon: Bold },
  { label: "Italic", icon: Italic },
  { label: "Underline", icon: Underline },
]

export default class Demo extends Component {
  log = useLog(this)

  onPressed = (label: string, pressed: boolean) => {
    this.log(`${label} ${pressed ? "on" : "off"}`)
  }

  <template>
    <Toolbar aria-label="Formatting" as |t|>
      {{#each styles key="label" as |style|}}
        <t.Toggle
          aria-label={{style.label}}
          @onPressedChange={{fn this.onPressed style.label}}
          as |p|
        >
          <p.Icon>{{icon style.icon}}</p.Icon>
        </t.Toggle>
      {{/each}}
      <t.Separator />
      <t.Button
        aria-label="Insert link"
        {{on "click" (fn this.log "Insert link")}}
      >
        {{icon Link}}
      </t.Button>
    </Toolbar>
  </template>
}
