import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Check, ChevronDown } from "lucide"
import { Checkbox } from "ember-ui-sdk/checkbox"
import { Dialog } from "ember-ui-sdk/dialog"
import { Select } from "ember-ui-sdk/select"
import { icon } from "../../../shared/ember/icon"

const modes = [
  { value: "true", label: "Modal" },
  { value: "trap-focus", label: "Trap focus" },
  { value: "false", label: "Non-modal" },
]

const notes = {
  true: "The rest of the page is inert and doesn't scroll.",
  "trap-focus":
    "Tab stays inside, and the page still scrolls and takes clicks.",
  false:
    "The page stays usable. Tab leaves the notes, and Escape closes them while focus is inside.",
}

export default class Modal extends Component {
  modes = modes
  @tracked mode = "false"
  @tracked outside = false

  get note() {
    return notes[this.mode as keyof typeof notes]
  }

  get modal() {
    return this.mode === "true"
      ? true
      : this.mode === "false"
        ? false
        : "trap-focus"
  }

  get showBackdrop() {
    return this.modal === true
  }

  onModeChange = (next: string | null) => {
    if (next) this.mode = next
  }

  onOutsideChange = (next: boolean | "indeterminate") => {
    this.outside = next === true
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <Select
          @items={{this.modes}}
          @value={{this.mode}}
          @onValueChange={{this.onModeChange}}
          as |s|
        >
          <s.Label>Modal</s.Label>
          <s.Trigger>
            <s.Value />
            {{icon ChevronDown}}
          </s.Trigger>
          <s.Content>
            {{#each this.modes key="value" as |option|}}
              <s.Item @value={{option.value}} as |item|>
                {{option.label}}
                <item.Indicator>{{icon Check}}</item.Indicator>
              </s.Item>
            {{/each}}
          </s.Content>
        </Select>
        <label data-slot="label">
          <Checkbox
            @checked={{this.outside}}
            @onCheckedChange={{this.onOutsideChange}}
            as |c|
          >
            <c.Indicator>{{icon Check}}</c.Indicator>
          </Checkbox>
          Close on outside press
        </label>
      </div>
      <Dialog
        @modal={{this.modal}}
        @closeOnOutsidePress={{this.outside}}
        as |d|
      >
        <d.Trigger>Open Notes</d.Trigger>
        {{#if this.showBackdrop}}
          <d.Backdrop />
        {{/if}}
        <d.Content>
          <div data-slot="stack">
            <d.Title>Notes</d.Title>
            <d.Description>{{this.note}}</d.Description>
          </div>
          <textarea aria-label="Notes">Call the printer about the proofs.</textarea>
          <div data-slot="row">
            <d.Close data-variant="solid">Done</d.Close>
          </div>
        </d.Content>
      </Dialog>
    </div>
  </template>
}
