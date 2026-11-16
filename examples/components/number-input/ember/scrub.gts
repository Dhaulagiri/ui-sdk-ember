import Component from "@glimmer/component"
import { fn } from "@ember/helper"
import { NumberInput } from "ember-ui-sdk/number-input"
import { MoveHorizontal } from "lucide"
import { icon } from "../../../shared/ember/icon"
import { useLog } from "../../../shared/ember/log"

const fields = [
  { label: "X position", handle: "X", defaultValue: 120 },
  { label: "Y position", handle: "Y", defaultValue: 48 },
  { label: "Width", handle: "W", defaultValue: 320, min: 0 },
  { label: "Height", handle: "H", defaultValue: 240, min: 0 },
]

export default class Scrub extends Component {
  log = useLog(this)

  onValueCommit = (label: string, value: number | null) => {
    this.log(`${label} ${value ?? "empty"}`)
  }

  <template>
    <div data-slot="card" role="group" aria-labelledby="frame-title">
      <h3 id="frame-title">Frame</h3>
      <div data-slot="grid">
        {{#each fields key="label" as |item|}}
          <NumberInput
            @defaultValue={{item.defaultValue}}
            @min={{item.min}}
            @onValueCommit={{fn this.onValueCommit item.label}}
            as |n|
          >
            <n.Group>
              <n.ScrubArea @pixelsPerStep={{1}}>
                <span aria-hidden="true">{{item.handle}}</span>
                <n.ScrubAreaCursor>{{icon MoveHorizontal}}</n.ScrubAreaCursor>
              </n.ScrubArea>
              <n.Control aria-label={{item.label}} />
            </n.Group>
          </NumberInput>
        {{/each}}
      </div>
    </div>
  </template>
}
