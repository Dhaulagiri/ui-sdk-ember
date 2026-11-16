import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { on } from "@ember/modifier"
import { Check, Copy } from "lucide"
import { Tooltip } from "ember-ui-sdk/tooltip"
import { icon } from "../../../shared/ember/icon"

const command = "npm install ember-ui-sdk"

export default class CopyExample extends Component {
  command = command
  @tracked copied = false

  get label() {
    return this.copied ? "Copied" : "Copy"
  }

  copy = () => {
    navigator.clipboard?.writeText(command).catch(() => {})
    this.copied = true
  }

  onOpenChangeComplete = (open: boolean) => {
    if (!open) {
      this.copied = false
    }
  }

  <template>
    <div data-slot="row">
      <code>{{this.command}}</code>
      <Tooltip
        @closeOnPress={{false}}
        @onOpenChangeComplete={{this.onOpenChangeComplete}}
        as |t|
      >
        <t.Trigger aria-label={{this.label}} {{on "click" this.copy}}>
          {{#if this.copied}}
            {{icon Check}}
          {{else}}
            {{icon Copy}}
          {{/if}}
        </t.Trigger>
        <t.Content>{{this.label}}</t.Content>
      </Tooltip>
    </div>
  </template>
}
