import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Check } from "lucide"
import { Checkbox } from "ember-ui-sdk/checkbox"
import { Resizable } from "ember-ui-sdk/resizable"
import { icon } from "../../../shared/ember/icon"

export default class Disabled extends Component {
  @tracked locked: boolean | "indeterminate" = false

  onCheckedChange = (next: boolean | "indeterminate") => {
    this.locked = next
  }

  get isLocked() {
    return this.locked === true
  }

  get unlocked() {
    return this.locked !== true
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <label data-slot="label">
          <Checkbox
            @checked={{this.locked}}
            @onCheckedChange={{this.onCheckedChange}}
            as |c|
          >
            <c.Indicator>{{icon Check}}</c.Indicator>
          </Checkbox>
          Lock layout
        </label>
      </div>
      <Resizable @disabled={{this.isLocked}} as |r|>
        <r.Panel @minSize={{15}}>
          <h3>Pinned</h3>
          <span data-slot="hint">2 notes</span>
        </r.Panel>
        <r.Handle @disabled={{true}} aria-label="Resize pinned" />
        <r.Panel @minSize={{15}}>
          <h3>Inbox</h3>
          <span data-slot="hint">3 unread</span>
        </r.Panel>
        <r.Handle aria-label="Resize inbox" />
        <r.Panel @minSize={{15}}>
          <h3>Message</h3>
          <span data-slot="hint">From Kofi Mensah</span>
        </r.Panel>
      </Resizable>
    </div>
  </template>
}
