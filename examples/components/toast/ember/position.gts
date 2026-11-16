import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { on } from "@ember/modifier"
import { Check, ChevronDown } from "lucide"
import { Select } from "ember-ui-sdk/select"
import { createToaster, ToastRegion } from "ember-ui-sdk/toast"
import { icon } from "../../../shared/ember/icon"

const sides = [
  { value: "top", label: "Top" },
  { value: "bottom", label: "Bottom" },
]
const aligns = [
  { value: "start", label: "Start" },
  { value: "center", label: "Center" },
  { value: "end", label: "End" },
]

export default class Position extends Component {
  toast = createToaster()
  sides = sides
  aligns = aligns
  @tracked side: "top" | "bottom" = "bottom"
  @tracked align: "start" | "center" | "end" = "end"

  willDestroy() {
    super.willDestroy()
    this.toast.dismiss()
  }

  onSideChange = (next: string | null) => {
    if (next) this.side = next as "top" | "bottom"
  }

  onAlignChange = (next: string | null) => {
    if (next) this.align = next as "start" | "center" | "end"
  }

  createEvent = () => {
    this.toast("Event created", { description: "Friday, June 12 at 10:00 AM" })
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <Select
          @items={{this.sides}}
          @value={{this.side}}
          @onValueChange={{this.onSideChange}}
          as |s|
        >
          <s.Label>Side</s.Label>
          <s.Trigger>
            <s.Value />
            {{icon ChevronDown}}
          </s.Trigger>
          <s.Content>
            {{#each this.sides key="value" as |option|}}
              <s.Item @value={{option.value}} as |item|>
                {{option.label}}
                <item.Indicator>{{icon Check}}</item.Indicator>
              </s.Item>
            {{/each}}
          </s.Content>
        </Select>
        <Select
          @items={{this.aligns}}
          @value={{this.align}}
          @onValueChange={{this.onAlignChange}}
          as |s|
        >
          <s.Label>Align</s.Label>
          <s.Trigger>
            <s.Value />
            {{icon ChevronDown}}
          </s.Trigger>
          <s.Content>
            {{#each this.aligns key="value" as |option|}}
              <s.Item @value={{option.value}} as |item|>
                {{option.label}}
                <item.Indicator>{{icon Check}}</item.Indicator>
              </s.Item>
            {{/each}}
          </s.Content>
        </Select>
      </div>
      <button type="button" {{on "click" this.createEvent}}>
        Create Event
      </button>
      <ToastRegion
        @toaster={{this.toast}}
        @side={{this.side}}
        @align={{this.align}}
        as |toast item t|
      >
        <t.Toast>
          <div data-slot="stack">
            <t.Title />
            <t.Description />
          </div>
        </t.Toast>
      </ToastRegion>
    </div>
  </template>
}
