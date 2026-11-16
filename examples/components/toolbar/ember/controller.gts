import Component from "@glimmer/component"
import { fn } from "@ember/helper"
import { on } from "@ember/modifier"
import { createToolbarController, Toolbar } from "ember-ui-sdk/toolbar"
import { Bold, Italic, Link } from "lucide"
import { icon } from "../../../shared/ember/icon"
import { useLog } from "../../../shared/ember/log"

const actions = [
  { label: "Bold", icon: Bold },
  { label: "Italic", icon: Italic },
  { label: "Insert link", icon: Link },
]

export default class Controller extends Component {
  logger = useLog(this)
  toolbar = createToolbarController()

  focusToolbar = () => this.toolbar.focus()

  log = (label: string) => this.logger(label)

  shortcut = (event: KeyboardEvent) => {
    if (event.altKey && event.key === "F10") {
      event.preventDefault()
      this.toolbar.focus()
    }
  }

  <template>
    <div data-slot="stack" {{on "keydown" this.shortcut}}>
      <div data-slot="controls">
        <button type="button" {{on "click" this.focusToolbar}}>Focus Toolbar</button>
      </div>
      <Toolbar
        @controller={{this.toolbar}}
        aria-label="Notes formatting"
        as |t|
      >
        {{#each actions key="label" as |action|}}
          <t.Button
            aria-label={{action.label}}
            {{on "click" (fn this.log action.label)}}
          >
            {{icon action.icon}}
          </t.Button>
        {{/each}}
      </Toolbar>
      <textarea
        aria-label="Notes"
        placeholder="Type, then press Alt+F10"
      ></textarea>
    </div>
  </template>
}
