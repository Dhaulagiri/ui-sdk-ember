import Component from "@glimmer/component"
import { fn } from "@ember/helper"
import { on } from "@ember/modifier"
import { Toolbar } from "ember-ui-sdk/toolbar"
import { ClipboardPaste, Copy, Redo, Scissors, Undo } from "lucide"
import { icon } from "../../../shared/ember/icon"
import { useLog } from "../../../shared/ember/log"

const clipboard = [
  { label: "Cut", icon: Scissors },
  { label: "Copy", icon: Copy },
  { label: "Paste", icon: ClipboardPaste },
]

export default class Group extends Component {
  log = useLog(this)

  <template>
    <Toolbar aria-label="Edit" as |t|>
      <t.Group aria-label="Clipboard" as |g|>
        {{#each clipboard key="label" as |item|}}
          <g.Button
            aria-label={{item.label}}
            {{on "click" (fn this.log item.label)}}
          >
            {{icon item.icon}}
          </g.Button>
        {{/each}}
      </t.Group>
      <t.Separator />
      <t.Group @disabled={{true}} aria-label="History" as |g|>
        <g.Button aria-label="Undo">{{icon Undo}}</g.Button>
        <g.Button aria-label="Redo">{{icon Redo}}</g.Button>
      </t.Group>
    </Toolbar>
  </template>
}
