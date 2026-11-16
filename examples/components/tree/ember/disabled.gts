import Component from "@glimmer/component"
import { array } from "@ember/helper"
import { tracked } from "@glimmer/tracking"
import { ChevronRight } from "lucide"
import { Switch } from "ember-ui-sdk/switch"
import { Tree } from "ember-ui-sdk/tree"
import { icon } from "../../../shared/ember/icon"

const items = [
  {
    value: "plans",
    label: "Plans",
    children: [
      { value: "free", label: "Free" },
      { value: "pro", label: "Pro" },
      { value: "enterprise", label: "Enterprise", disabled: true },
    ],
  },
  {
    value: "legacy",
    label: "Legacy plans",
    disabled: true,
    children: [{ value: "starter", label: "Starter" }],
  },
  { value: "custom", label: "Custom" },
]

type Node = {
  value: string
  label: string
  children?: Node[]
  disabled?: boolean
}

class Nodes extends Component<{
  Args: { parts: Record<string, unknown>; items: Node[] }
}> {
  <template>
    {{#each @items key="value" as |item|}}
      <@parts.Item @value={{item.value}} @disabled={{item.disabled}} as |i|>
        <i.Label>
          {{#if item.children}}
            <i.Indicator>{{icon ChevronRight}}</i.Indicator>
          {{/if}}
          {{item.label}}
        </i.Label>
        {{#if item.children}}
          <i.Group as |g|>
            <Nodes @parts={{g}} @items={{item.children}} />
          </i.Group>
        {{/if}}
      </@parts.Item>
    {{/each}}
  </template>
}

export default class Disabled extends Component {
  @tracked focusable = true
  items = items

  onFocusableChange = (next: boolean) => {
    this.focusable = next
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <label data-slot="label">
          <Switch
            @checked={{this.focusable}}
            @onCheckedChange={{this.onFocusableChange}}
            as |s|
          >
            <s.Thumb />
          </Switch>
          Focusable when disabled
        </label>
      </div>
      <Tree
        aria-label="Plans"
        @items={{this.items}}
        @defaultExpanded={{array "plans"}}
        @focusableWhenDisabled={{this.focusable}}
        as |t|
      >
        <Nodes @parts={{t}} @items={{this.items}} />
      </Tree>
    </div>
  </template>
}
